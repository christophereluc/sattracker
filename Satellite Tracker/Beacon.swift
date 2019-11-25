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


struct BeaconResponse {
    let data: Beacon
}

extension BeaconResponse: Decodable {
    enum BeaconResponseCodingKeys: String, CodingKey {
        case data
    }
    
    init (from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: BeaconResponseCodingKeys.self)
        
        data = try response.decode(Beacon.self, forKey: .data)
    }
}

struct Beacon {
    let satid: Int
    let name, uplink, downlink, beacon, callsign, mode: String?
}

extension Beacon: Decodable {
    enum BeaconKeys: String, CodingKey {
        case name
        case satid
        case uplink
        case downlink
        case beacon
        case callsign
        case mode
    }
    
    init (from decoder: Decoder) throws {
        let beac = try decoder.container(keyedBy: BeaconKeys.self)
        
        name = try beac.decode(String.self, forKey: .name)
        satid = try beac.decode(Int.self, forKey: .satid)
        uplink = try beac.decode(String.self, forKey: .uplink)
        downlink = try beac.decode(String.self, forKey: .downlink)
        beacon = try beac.decode(String.self, forKey: .beacon)
        callsign = try beac.decode(String.self, forKey: .callsign)
        mode = try beac.decode(String.self, forKey: .mode)
    }
}

extension Beacon: CustomStringConvertible {
    var description: String {
        return "(\(name)\n\(satid)\n\(uplink)\n\(downlink)\n\(downlink)\n\(beacon)\n\(callsign)\n\(mode))"
    }
}
