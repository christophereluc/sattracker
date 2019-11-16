//
//  Position.swift
//  Satellite Tracker
//
//  Created by Kamille Delgardo on 11/6/19.
//

import Foundation

class Position {
    var latitude: Float!
    var longitude: Float!
    var altitude: Float!
    
    init(latitude: Float, longitude: Float, altitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}
