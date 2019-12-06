//
//  Satellite_TrackerTests.swift
//  Satellite TrackerTests
//
//  Created by Christopher Luc on 11/25/19.
//

import XCTest
@testable import Satellite_Tracker

class Satellite_TrackerTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    let nearbyJson = Data("""
    {"data": {"satellites": [{"satid": 44330, "satname": "RAAVANA1", "intDesignator": "1998-067QF", "launchDate": "1998-11-20", "satlat": 51.6316, "satlng": -118.4669, "satalt": 409.2799, "uplink": "", "downlink": "437.375", "beacon": "437.375", "mode": "4800bps GMSK CW"}], "iss": {"satid": 43678, "satname": "DIWATA 2B (PO-101)", "intDesignator": "2018-084H", "launchDate": "2018-10-29", "satlat": 32.1231, "satlng": -144.1986, "satalt": 592.3276, "uplink": "437.500", "downlink": "145.900", "beacon": "145.900", "mode": "FM APRS Digipeater CW"}}}
    """.utf8)
    
    func testCreateNearbySatelliteFromJson() {
        let data = try! JSONDecoder().decode(NearbySatelliteResponse.self, from: nearbyJson)
        XCTAssertNotNil(data)
        XCTAssertNotNil(data.data)
        XCTAssertNotNil(data.data.satellites)
        XCTAssertEqual(data.data.satellites.count, 1)
        XCTAssertEqual(data.data.satellites[0].satid, 44330)
        XCTAssertEqual(data.data.satellites[0].satname, "RAAVANA1")
        XCTAssertEqual(data.data.satellites[0].intDesignator, "1998-067QF")
        XCTAssertEqual(data.data.satellites[0].launchDate, "1998-11-20")
        XCTAssertEqual(data.data.satellites[0].satlat, 51.6316)
        XCTAssertEqual(data.data.satellites[0].satlng, -118.4669)
        XCTAssertEqual(data.data.satellites[0].satalt, 409.2799)
        XCTAssertEqual(data.data.satellites[0].satUplink, "")
        XCTAssertEqual(data.data.satellites[0].satDownlink, "437.375")
        XCTAssertEqual(data.data.satellites[0].satBeacon, "437.375")
        XCTAssertEqual(data.data.satellites[0].satMode, "4800bps GMSK CW")
        XCTAssertNotNil(data.data.iss)
        XCTAssertEqual(data.data.iss!.satid, 43678)
        XCTAssertEqual(data.data.iss!.satname, "DIWATA 2B (PO-101)")
        XCTAssertEqual(data.data.iss!.intDesignator, "2018-084H")
        XCTAssertEqual(data.data.iss!.launchDate, "2018-10-29")
        XCTAssertEqual(data.data.iss!.satlat, 32.1231)
        XCTAssertEqual(data.data.iss!.satlng, -144.1986)
        XCTAssertEqual(data.data.iss!.satalt, 592.3276)
        XCTAssertEqual(data.data.iss!.satUplink, "437.500")
        XCTAssertEqual(data.data.iss!.satDownlink, "145.900")
        XCTAssertEqual(data.data.iss!.satBeacon, "145.900")
        XCTAssertEqual(data.data.iss!.satMode, "FM APRS Digipeater CW")
    }
    
}
