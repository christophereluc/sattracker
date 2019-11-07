//
//  Satellite.swift
//  Satellite Tracker
//
//  Created by Kamille Delgardo on 11/6/19.
//

import Foundation
import CoreLocation

func formatDate(launchDate: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: launchDate)!
    return date
}

class Satellite {
    var name: String?
    var designator: String?
    var launchDate: Date!
    var id: Int?
    var location: CLLocation?
    var beacon: Beacon?
    var Path: Path?
    
    // Initialization
    init(name: String, launchDate: String, id: Int, location: CLLocation) {
        self.name = name
        self.launchDate = formatDate(launchDate: launchDate)
    }
}
