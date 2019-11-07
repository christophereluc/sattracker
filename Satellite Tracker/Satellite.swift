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
    var position: Position?
    
    // Initialization
    init(name: String, launchDate: NSDate, id: Int, location: CLLocation) {
        <#statements#>
    }
}
