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
    var manager = NetworkManager()
    
    func testBeaconCompletion(data: BeaconResponse?, error: String?) {
        if let data = data {
            print(data)
        }
        else if let error = error {
            print(error)
        }
    }
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let beacon = manager.getBeacons(id: 41465, completion: testBeaconCompletion)
    
        
        text?.text = "\(beacon)"
    }
}
