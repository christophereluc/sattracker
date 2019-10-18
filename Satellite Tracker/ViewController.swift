//
//  ViewController.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 10/6/19.
//

import UIKit
import SceneKit
import ARKit

@available(iOS 11.0, *)
class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBasicARScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func setupBasicARScene() {
        
        // Set the view's delegate
        sceneView.delegate = self
        #if DEBUG
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // debug options
        sceneView.debugOptions = [
            ARSCNDebugOptions.showFeaturePoints,
            ARSCNDebugOptions.showWorldOrigin
        ]
        #endif
        // Create a new scene and set it to the view
        sceneView.scene = SCNScene()
        
    }


}

