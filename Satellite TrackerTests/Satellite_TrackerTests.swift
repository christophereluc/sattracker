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
    {"data": {"satellites": [{"satid": 14129, "satname": "OSCAR 10", "intDesignator": "1983-058B", "launchDate": "1983-06-16", "satlat": 21.046, "satlng": -170.4703, "satalt": 21025.7089}], "iss": {"satid": 26609, "satname": "AMSAT OSCAR 40", "intDesignator": "2000-072B", "launchDate": "2000-11-16", "satlat": -9.3149, "satlng": -157.4545, "satalt": 58662.0491}}}
    """.utf8)
    
    func testCreateNearbySatelliteFromJson() {
        let data = try! JSONDecoder().decode(NearbySatelliteResponse.self, from: nearbyJson)
        XCTAssertNotNil(data)
        XCTAssertNotNil(data.data)
        XCTAssertNotNil(data.data.satellites)
        XCTAssertEqual(data.data.satellites.count, 1)
        XCTAssertEqual(data.data.satellites[0].satid, 14129)
        XCTAssertEqual(data.data.satellites[0].satname, "OSCAR 10")
        XCTAssertEqual(data.data.satellites[0].intDesignator, "1983-058B")
        XCTAssertEqual(data.data.satellites[0].launchDate, "1983-06-16")
        XCTAssertEqual(data.data.satellites[0].satlat, 21.046)
        XCTAssertEqual(data.data.satellites[0].satlng, -170.4703)
        XCTAssertEqual(data.data.satellites[0].satalt, 21025.7089)
        XCTAssertNotNil(data.data.iss)
        XCTAssertEqual(data.data.iss!.satid, 26609)
        XCTAssertEqual(data.data.iss!.satname, "AMSAT OSCAR 40")
        XCTAssertEqual(data.data.iss!.intDesignator, "2000-072B")
        XCTAssertEqual(data.data.iss!.launchDate, "2000-11-16")
        XCTAssertEqual(data.data.iss!.satlat, -9.3149)
        XCTAssertEqual(data.data.iss!.satlng, -157.4545)
        XCTAssertEqual(data.data.iss!.satalt, 58662.0491)
    }
    
}
