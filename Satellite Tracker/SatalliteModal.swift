//
//  SatalliteModal.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 10/27/19.
//

import UIKit
import CoreLocation

class ModalViewController: UIViewController {

    @IBOutlet var text: UITextView?
    
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text?.text = "\(location!)"
    }
}
