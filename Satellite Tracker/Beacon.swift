//
//  Beacon.swift
//  Satellite Tracker
//
//  Created by Kamille Delgardo on 11/6/19.
//

import Foundation

class Beacon {
    var uplink: String?
    var downlink: String?
    var beacon: String?
    var callsign: String?
    var mode: String?
    
    init(
        uplink: String?,
        downlink: String?,
        beacon: String?,
        callsign: String?,
        mode: String?) {
        self.uplink = uplink
        self.downlink = downlink
        self.beacon = beacon
        self.callsign = callsign
        self.mode = mode
    }
}
