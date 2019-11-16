////
////  Position.swift
////  Satellite Tracker
////  Creates model for data returned by /tracking endpoint
////
////  Created by Kamille Delgardo on 11/6/19.
////
////  example returned data:
///*      "startAz": 159.94,
//        "startAzCompass": "SSE",
//        "startUTC": 1573145495,
//        "maxAz": 86.7,
//        "maxAzCompass": "E",
//        "maxEl": 41.91,
//        "maxUTC": 1573146185,
//        "endAz": 14.9,
//        "endAzCompass": "N",
//        "endUTC": 1573146865
// */
//
//
//
//import Foundation
//
//enum Direction: String {
//    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
//}
//
//struct PassResponse {
//    let data: [Pass]
//}
//
//extension PassResponse: Decodable {
//    enum PassResponseCodingKeys: String, CodingKey {
//        case data
//    }
//    
//    init (from decoder: Decoder) throws {
//        let response = try decoder.container(keyedBy: PassResponseCodingKeys.self)
//        
//        data = try response.decode([Pass].self, forKey: .data)
//    }
//}
//
//struct Pass {
//    let satid: Int
//    let startAzCompass, maxAzCompass, endAzCompass: Direction
//    let startUTC, maxUTC, endUTC: Date
//    let startAz, maxAz, endAz, maxEl: Float
//}
//
//extension Pass: Decodable {
//    enum PassKeys: String, CodingKey {
//        case satid
//        case startAz
//        case startAzCompass
//        case startUTC
//        case maxAz
//        case maxAzCompass
//        case maxEl
//        case maxUTC
//        case endAz
//        case endAzCompass
//        case endUTC
//    }
//    
//    init (from decoder: Decoder) throws {
//        let pass = try decoder.container(keyedBy: PassKeys.self)
//        
//        satid = try pass.decode(Int.self, forKey: satid)
//        startAz = try pass.decode(Float.self, forKey: startAz)
//        startAzCompass = try pass.decode(Direction(rawValue: String.self), forKey: startAzCompass)
//        startUTC = try pass.decode(Date(timeIntervalSince1970: TimeInterval(Int.self), forKey: startUTC)
//        maxAz = try pass.decode(Float.self, forKey: maxAz)
//        maxAzCompass = try pass.decode(Direction(rawValue: String.self), forKey: maxAzCompass)
//        maxUTC = try pass.decode(Date(timeIntervalSince1970: TimeInterval(Int.self), forKey: maxUTC)
//        maxEl = try pass.decode(Float.self, forKey: maxEl)
//        endAz = try pass.decode(Float.self, forKey: endAz)
//        endAzCompass = try pass.decode(Direction(rawValue: String.self), forKey: endAzCompass)
//        endUTC = try pass.decode(Date(timeIntervalSince1970: TimeInterval(Int.self)), forKey: endUTC)
//    }
//}
