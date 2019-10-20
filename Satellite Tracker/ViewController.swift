//
//  ViewController.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 10/6/19.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

@available(iOS 11.0, *)
class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        checkLocationServices()
        setupBasicARScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create the arworld config
        let configuration = ARWorldTrackingConfiguration()
        // And now run it
        sceneView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the session when the view disappears
        sceneView.session.pause()
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
        
        // Set the view delegate
        sceneView.delegate = self
        #if DEBUG
        
        //Debug options, will not appear in a non debug build
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints ]
        #endif
        sceneView.scene = SCNScene()
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
}

