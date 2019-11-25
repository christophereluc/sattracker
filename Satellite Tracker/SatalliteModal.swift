//
//  SatalliteModal.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 10/27/19.
//

import UIKit
import CoreLocation

class ModalViewController: UIViewController {

    var text:String = ""
    @IBOutlet var textLabel: UITextView?
    
//    var location: CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel?.text = "\(String(describing: text))"
    }
}
