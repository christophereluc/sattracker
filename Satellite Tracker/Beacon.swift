//
//  Beacon.swift
//  Satellite Tracker
//
//  Created by Kamille Delgardo on 11/6/19.
/*  Example API return data:
    {
        "name": "CubeBel-1(BSUSat-1)",
        "id": "43666",
        "uplink": "436.200",
        "downlink": "436.200",
        "beacon": "436.990*",
        "mode": "4k8/9k6* GMSK Digipeater",
        "callsign": "EU10S"
    }  */


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
