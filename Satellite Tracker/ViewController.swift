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

        setupBasicARScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create the arworld config
        let configuration = ARWorldTrackingConfiguration()

        // And now run it
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the session when the view disappears
        sceneView.session.pause()
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


}

