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
class ViewController: UIViewController {

    var nearbySatellites: [NearbySatellite] = []

    let sceneLocationView = SceneLocationView()
    let locationManager = CLLocationManager()
    let networkManager = NetworkManager()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        setupBasicARScene()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
        sceneLocationView.run()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the session when the view disappears
        sceneLocationView.pause()
        //Stop timer from firing if the screen is backgrounded
        timer?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    var calledOnce = false

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

}

// MARK: - LNTouchDelegate
@available(iOS 11.0, *)
extension ViewController: LNTouchDelegate {
    func locationNodeTouched(node: AnnotationNode) {

        if let tag = node.view?.tag {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "modalViewController") as! ModalViewController
            
            let nearbySatellite = nearbySatellites[tag]
            let coordinate = CLLocationCoordinate2D(latitude: nearbySatellite.satlat, longitude: nearbySatellite.satlng)
            let location = CLLocation(coordinate: coordinate, altitude: (nearbySatellite.satalt * 1000))
            newViewController.location = location

            self.present(newViewController, animated: true, completion: nil)
        }

    }

}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: execute)
    }
}

//Extension for ARKit/ARCL related methods
@available(iOS 11.0, *)
extension ViewController: ARSCNViewDelegate {

    func setupBasicARScene() {

        sceneLocationView.locationNodeTouchDelegate = self
        sceneLocationView.arViewDelegate = self
        sceneLocationView.locationNodeTouchDelegate = self
        sceneLocationView.orientToTrueNorth = true

        view.addSubview(sceneLocationView)
        sceneLocationView.frame = view.bounds
    }

    /// Adds the appropriate ARKit models to the scene.  Note: that this won't
    /// do anything until the scene has a `currentLocation`.  It "polls" on that
    /// and when a location is finally discovered, the models are added.
    func addSceneModels(satellites: [NearbySatellite], imageName: String) {
        // 1. Don't try to add the models to the scene until we have a current location
        guard sceneLocationView.sceneLocationManager.currentLocation != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addSceneModels(satellites: satellites, imageName: imageName)
            }
            return
        }
        sceneLocationView.removeAllNodes()
        satellites.forEach { satellite in
            //N2YO returns altiltue as KM, but CoreLocation expects altitude in meters, so convert before passing in.
            let node = buildNode(nearbySatellite: satellite, imageName: imageName)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
        }
    }

    func buildNode(nearbySatellite: NearbySatellite, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: nearbySatellite.satlat, longitude: nearbySatellite.satlng)
        let location = CLLocation(coordinate: coordinate, altitude: (nearbySatellite.satalt * 1000))
        let image = UIImage(named: imageName)!
        let imageView = UIImageView(image: image)

        let node = LocationAnnotationNode(location: location, view: imageView)
        return setNodeViewAndTag(node: node, satellite: nearbySatellite, view: imageView)

    }

    //MARK This is hacky, but is resolved in ARCL 1.2.2, so remove this if library updated before DEC
    func setNodeViewAndTag(node: LocationAnnotationNode, satellite: NearbySatellite, view: UIView) -> LocationAnnotationNode {
        //Tag will be the index of the inserted CLLocation
        let tag = nearbySatellites.count
        nearbySatellites.append(satellite)
        //Now set tag for retrieval later
        view.tag = tag
        node.annotationNode.view = view
        return node
    }

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

//MARK Location services extension
extension ViewController: CLLocationManagerDelegate {
    func checkLocationServices() {

        let locationAuthorizationStatus = CLLocationManager.authorizationStatus()

        switch locationAuthorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization() // This is where you request permission to use location services
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                handleAuthorized()
            }
            //MARK Handle services not enabled?
        case .restricted, .denied:
            showLocationRequiredAlert()
        }
    }

    //Handles the authorized case
    func handleAuthorized() {
        self.locationManager.startUpdatingLocation()
        //If old timer isn't null, invalidate it
        timer?.invalidate()
        //Start a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true, block: updateSatellites(timer:))
        //Immediately fire the timer so that we can get our first set of data
        timer?.fire()
    }

    //Shows the dialog for displaying why we need location services permission
    func showLocationRequiredAlert() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(title: "Location Services Required", message: "Location services are required to track satellites relative to phone locations", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Allow Access", style: .default, handler:  {
            (alert) -> Void in UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    //Delegate method called when authorization status is changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        timer?.invalidate()
        checkLocationServices()
    }

    //Called when location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        //MARK just a test to get the API call to occur
        if calledOnce == false {
            calledOnce = true
            networkManager.getBeacons(id: 41465, completion: testBeaconCompletion)
            networkManager.getPath(id: 41465, location: manager.location!, completion: testPathCompletion)
        }
    }

}

//Extension to handle network requests/responses
extension ViewController {

    func updateSatellites(timer: Timer) {
        if let location = locationManager.location {
            networkManager.getNearbySatellites(location: location, completion: handleNearbySatelliteResults(data:error:))
        }
        else {
            //MARK handle error case with dialog
            print("error with location?")
        }
    }

    func handleNearbySatelliteResults(data: NearbySatellites?, error: String?) {
        if let data = data {
            //Rejoin main thread since this is called as a result of a bg threaded network call
            DispatchQueue.main.async {
                self.addSceneModels(satellites: data.satellites, imageName: "satellite")
                if let iss = data.iss {
                    self.addSceneModels(satellites: [iss], imageName: "iss")
                }
            }
        }
        else if let error = error {
            //MARK handle error case with dialog
            print(error)
        }
    }
}
