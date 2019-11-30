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
    
    @IBOutlet weak var Sat_Name: UILabel!
    
    @IBOutlet weak var Sat_ID: UILabel!
    
    @IBOutlet weak var Sat_Uplink: UILabel!
    
    
    @IBOutlet weak var Sat_Downlink: UILabel!
    
    @IBOutlet weak var Sat_Beacon: UILabel!
    
    @IBOutlet weak var Sat_Callsign: UILabel!
    
    @IBOutlet weak var Sat_Mode: UILabel!

    var beacon: Beacon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Sat_ID.text = String(describing:beacon?.satid)
        Sat_Name.text = beacon?.name
        
        Sat_Beacon.text = beacon?.beacon
        
        Sat_Uplink.text = beacon?.uplink
        
        Sat_Downlink.text = beacon?.downlink
        
        Sat_Callsign.text = beacon?.callsign
        
        Sat_Mode.text = beacon?.mode
        
    }
}
