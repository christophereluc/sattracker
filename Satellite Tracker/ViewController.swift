//
//  ViewController.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 10/6/19.
//

import ARCL
import UIKit
import SceneKit
import ARKit
import CoreLocation

@available(iOS 11.0, *)
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationData: [CLLocation] = []
    
    let sceneLocationView = SceneLocationView()
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        checkLocationServices()
        setupBasicARScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the session when the view disappears
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    func showLocationRequiredAlert() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(title: "Location Services Required", message: "Location services are required to track satellites relative to phone locations", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Allow Access", style: .default, handler:  {
            (alert) -> Void in UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func setupBasicARScene() {
        
        sceneLocationView.locationNodeTouchDelegate = self
        sceneLocationView.arViewDelegate = self
        sceneLocationView.locationNodeTouchDelegate = self
        sceneLocationView.orientToTrueNorth = true
        
        view.addSubview(sceneLocationView)
        sceneLocationView.frame = view.bounds
    }
    
    func checkLocationServices() {
        
        let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        switch locationAuthorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization() // This is where you request permission to use location services
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            showLocationRequiredAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways || status != .authorizedWhenInUse {
            checkLocationServices()
        }
    }
    
    var calledOnce = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        //MARK just a test to get the API call to occur
        if calledOnce == false {
            calledOnce = true
            networkManager.getNearbySatellites(location: manager.location!, completion: testCompletionOfNearby)
            networkManager.getBeacons(id: 41465, completion: testBeaconCompletion)
            networkManager.getPath(id: 41465, location: manager.location!, completion: testPathCompletion)
        }
    }
    
    func testCompletionOfNearby(data: NearbySatellites?, error: String?) {
        if let data = data {
            //Rejoin main thread since this is called as a result of a bg threaded network call
            DispatchQueue.main.async {
                self.addSceneModels(satellites: data.satellites)
                if let iss = data.iss {
                    self.addSceneModels(satellites: [iss])
                }
            }
        }
        else if let error = error {
            print(error)
        }
    }
    
    func testBeaconCompletion(data: BeaconResponse?, error: String?) {
        if let data = data {
            print(data)
        }
        else if let error = error {
            print(error)
        }
    }
    
    func testPathCompletion(data: PathResponse?, error: String?) {
        if let data = data {
            print(data)
        }
        else if let error = error {
            print(error)
        }
    }
    
    //MARK Empty function to pass in as completion block to network manager
    func testCompletion(data: [Any]?, error: String?) {
    }
    
}

// MARK: - LNTouchDelegate
@available(iOS 11.0, *)
extension ViewController: LNTouchDelegate {
    func locationNodeTouched(node: AnnotationNode) {
                
        if let tag = node.view?.tag {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "modalViewController") as! ModalViewController
            newViewController.location = locationData[tag]
            
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
    
}

@available(iOS 11.0, *)
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Added SCNNode: \(node)")    // you probably won't see this fire
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        print("willUpdate: \(node)")    // you probably won't see this fire
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("Camera: \(camera)")
    }
    
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: execute)
    }
}


@available(iOS 11.0, *)
extension ViewController {
    
    /// Adds the appropriate ARKit models to the scene.  Note: that this won't
    /// do anything until the scene has a `currentLocation`.  It "polls" on that
    /// and when a location is finally discovered, the models are added.
    func addSceneModels(satellites: [NearbySatellite]) {
        // 1. Don't try to add the models to the scene until we have a current location
        guard sceneLocationView.sceneLocationManager.currentLocation != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addSceneModels(satellites: satellites)
            }
            return
        }
                    
        satellites.forEach { satellite in
            //N2YO returns altiltue as KM, but CoreLocation expects altitude in meters, so convert before passing in.
            let node = buildNode(latitude: satellite.satlat, longitude: satellite.satlng, altitude: (satellite.satalt * 1000))
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
        }
    }
    
    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                   altitude: CLLocationDistance) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = UIImage(named: "satellite")!
        let imageView = UIImageView(image: image)

        let node = LocationAnnotationNode(location: location, view: imageView)
        return setNodeViewAndTag(node: node, location: location, view: imageView)

    }

    //MARK This is hacky, but is resolved in ARCL 1.2.2, so remove this if library updated before DEC
    func setNodeViewAndTag(node: LocationAnnotationNode, location: CLLocation, view: UIView) -> LocationAnnotationNode {
        //Tag will be the index of the inserted CLLocation
        let tag = locationData.count
        locationData.append(location)
        //Now set tag for retrieval later
        view.tag = tag
        node.annotationNode.view = view
        return node
    }
}
