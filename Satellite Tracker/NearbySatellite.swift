//
//  NearbySatellite.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 11/7/19.
//

import Foundation


struct NearbySatelliteResponse {
    let data: NearbySatellites
}

extension NearbySatelliteResponse: Decodable {
    enum NearbySatelliteResponseCodingKeys: String, CodingKey {
        case data
    }

    init (from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: NearbySatelliteResponseCodingKeys.self)

        data = try response.decode(NearbySatellites.self, forKey: .data)
    }
}

struct NearbySatellites {
    let satellites: [NearbySatellite]
    let iss: NearbySatellite?
}

extension NearbySatellites: Decodable {
    enum NearbySatellitesCodingKeys: String, CodingKey {
        case satellites
        case iss
    }

    init (from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: NearbySatellitesCodingKeys.self)

        satellites = try response.decode([NearbySatellite].self, forKey: .satellites)
        iss = try response.decodeIfPresent(NearbySatellite.self, forKey: .iss)
    }
}

struct NearbySatellite {
    let satid: Int
    let satname, intDesignator, launchDate, satUplink, satDownlink, satMode: String
    let satlat, satlng, satalt, satBeacon: Double

}

extension NearbySatellite: Decodable {
    enum NearbySatelliteKeys: String, CodingKey {
        case satid
        case satname
        case intDesignator
        case launchDate
        case satlat
        case satlng
        case satalt
        case satUplink
        case satDownlink
        case satBeacon
        case satMode
    }

    init (from decoder: Decoder) throws {
        let nearbySatellite = try decoder.container(keyedBy: NearbySatelliteKeys.self)

        satid = try nearbySatellite.decode(Int.self, forKey: .satid)
        satname = try nearbySatellite.decode(String.self, forKey: .satname)
        intDesignator = try nearbySatellite.decode(String.self, forKey: .intDesignator)
        launchDate = try nearbySatellite.decode(String.self, forKey: .launchDate)
        satlat = try nearbySatellite.decode(Double.self, forKey: .satlat)
        satlng = try nearbySatellite.decode(Double.self, forKey: .satlng)
        satalt = try nearbySatellite.decode(Double.self, forKey: .satalt)
        satUplink = try nearbySatellite.decode(String.self, forKey: .satUplink)
        satDownlink = try nearbySatellite.decode(String.self, forKey: .satDownlink)
        satMode = try nearbySatellite.decode(String.self, forKey: .satMode)
        satBeacon = try nearbySatellite.decode(Double.self, forKey: .satBeacon)
    }
}
