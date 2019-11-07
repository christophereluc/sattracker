//
//  Satellite.swift
//  Satellite Tracker
//
//  Created by Kamille Delgardo on 11/6/19.
//

import Foundation
import CoreLocation

class Satellite {
    var name: String?
    var designator: String?
    var launchDate: NSDate?
    var id: Int?
    var location: CLLocation?
    var beacon: Beacon?
    var Path: Path?
    
    // Initialization
    init(name: String, launchDate: String, id: Int, location: CLLocation) {
        self.name = name
        self.launchDate =  
    }
}
