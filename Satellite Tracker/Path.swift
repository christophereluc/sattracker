//
//  Position.swift
//  Satellite Tracker
//  Creates model for data returned by /tracking endpoint
//
//  Created by Kamille Delgardo on 11/6/19.
//
//  example returned data:
/*      "startAz": 159.94,
        "startAzCompass": "SSE",
        "startUTC": 1573145495,
        "maxAz": 86.7,
        "maxAzCompass": "E",
        "maxEl": 41.91,
        "maxUTC": 1573146185,
        "endAz": 14.9,
        "endAzCompass": "N",
        "endUTC": 1573146865
 */



import Foundation

struct PathResponse {
    let data: [Path]
}

extension PathResponse: Decodable {
    enum PathResponseCodingKeys: String, CodingKey {
        case data
    }
    
    init (from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: PathResponseCodingKeys.self)
        
        data = try response.decode([Path].self, forKey: .data)
    }
}

struct Path {
    let startUTC, maxUTC, endUTC: Int
    let startAzCompass, maxAzCompass, endAzCompass: String
    let startAz, maxAz, endAz, maxEl: Decimal
}

extension Path: Decodable {
    enum PathKeys: String, CodingKey {
        case startAz
        case startAzCompass
        case startUTC
        case maxAz
        case maxAzCompass
        case maxEl
        case maxUTC
        case endAz
        case endAzCompass
        case endUTC
    }
    
    init (from decoder: Decoder) throws {
        let path = try decoder.container(keyedBy: PathKeys.self)
        
        startAz = try path.decode(Decimal.self, forKey: .startAz)
        startAzCompass = try path.decode(String.self, forKey: .startAzCompass)
        startUTC = try path.decode(Int.self, forKey: .startUTC)
        maxAz = try path.decode(Decimal.self, forKey: .maxAz)
        maxAzCompass = try path.decode(String.self, forKey: .maxAzCompass)
        maxUTC = try path.decode(Int.self, forKey: .maxUTC)
        maxEl = try path.decode(Decimal.self, forKey: .maxEl)
        endAz = try path.decode(Decimal.self, forKey: .endAz)
        endAzCompass = try path.decode(String.self, forKey: .endAzCompass)
        endUTC = try path.decode(Int.self, forKey: .endUTC)
    }
}
