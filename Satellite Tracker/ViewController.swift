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
    let image = UIImage(systemName: "mappin.circle.fill")!
    var coordinate: CLLocationCoordinate2D?
    
    let networkManager = NetworkManager()
    
    /// Whether to display some debugging data
    /// This currently displays the coordinate of the best location estimate
    /// The initial value is respected
    let displayDebugging = true
    
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
        
        sceneLocationView.showAxesNode = true
        sceneLocationView.showFeaturePoints = displayDebugging
        sceneLocationView.locationNodeTouchDelegate = self
        //        sceneLocationView.delegate = self // Causes an assertionFailure - use the `arViewDelegate` instead:
        sceneLocationView.arViewDelegate = self
        sceneLocationView.locationNodeTouchDelegate = self

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
        }
    }
    
    func testCompletionOfNearby(data: NearbySatelliteResponse?, error: String?) {
        if let data = data {
            //Rejoin main thread since this is called as a result of a bg threaded network call
            DispatchQueue.main.async {
                self.addSceneModels(satellites: data.data)
            }
        }
        else if let error = error {
            print(error)
        }
    }
    
    func passesData(id: Int) {
        
    }
    
    func beaconData(ids: [Int]) {
        networkManager.getBeacons(completion: testCompletion(data:error:))
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
        
        let box = SCNBox(width: 1, height: 0.2, length: 5, chamferRadius: 0.25)
        box.firstMaterial?.diffuse.contents = UIColor.gray.withAlphaComponent(0.5)
        
        
        // 3. If not, then show the
        satellites.forEach { satellite in
            let node = buildNode(latitude: satellite.satlat, longitude: satellite.satlng, altitude: satellite.satalt)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
        }
        
        // There are many different ways to add lighting to a scene, but even this mechanism (the absolute simplest)
        // keeps 3D objects fron looking flat
        sceneLocationView.autoenablesDefaultLighting = true
        
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
    
    func buildViewNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                       altitude: CLLocationDistance, text: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = text
        label.backgroundColor = .green
        label.textAlignment = .center
        let node = LocationAnnotationNode(location: location, view: label)
        return setNodeViewAndTag(node: node, location: location, view: label)
        
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
