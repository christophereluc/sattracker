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

enum Direction: String {
    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
}

class Path {
    var startAz: Float
    var startAzCompass: Direction
    var startUTC: Date
    var maxAz: Float
    var maxAzCompass: Direction
    var maxEl: Float?
    var maxUTC: Date
    var endAz: Float
    var endAzCompass: Direction
    var endUTC: NSDate
    
    init(
        startAz: Float,
        startAzCompass: String,
        startUTC: Int,
        maxAz: Float,
        maxAzCompass: String,
        maxEl: Float,
        maxUTC: Int,
        endAz: Float,
        endAzCompass: String,
        endUTC: Date){
        
        self.startAz = startAz
        self.startAzCompass = Direction(rawValue: startAzCompass)!
        self.startUTC = Date(timeIntervalSince1970: TimeInterval(startUTC))
        self.maxAz = maxAz
        self.maxAzCompass = Direction(rawValue: maxAzCompass)!
        self.maxEl = maxEl
        self.maxUTC = Date(timeIntervalSince1970: TimeInterval(maxUTC))
        self.endAz = endAz
        self.endAzCompass = Direction(rawValue: endAzCompass)!
        self.endUTC = Date(timeIntervalSince1970: TimeInterval(endUTC))
    }
}
