//
//  SeatGeekVenueTests.swift
//  SeatGeekServiceTests
//
//  Created by Maksim Orlovich on 1/2/19.
//

import XCTest
import Foundation
@testable import SeatGeekService

class SeatGeekVenueTests: XCTestCase {
    func testBasicDecoding() {
        let venueJSON =
        """
        {
            "links": [],
            "metro_code": 753,
            "postal_code": "85374",
            "timezone": "America/Phoenix",
            "has_upcoming_events": true,
            "id": 3930,
            "city": "Surprise",
            "extended_address": "Surprise, AZ 85374",
            "display_location": "Surprise, AZ",
            "state": "AZ",
            "score": 0.5899753,
            "location": {
                "lat": 33.6269,
                "lon": -112.377
            },
            "access_method": null,
            "num_upcoming_events": 29,
            "address": "15754 North Bullard",
            "slug": "surprise-stadium",
            "name": "Surprise Stadium",
            "url": "https://seatgeek.com/venues/surprise-stadium/tickets",
            "country": "US",
            "popularity": 0,
            "name_v2": "Surprise Stadium"
        }
        """
        
        do {
            let venue = try JSONDecoder.seatGeekDecoder.decode(SeatGeekVenue.self, from: Data(venueJSON.utf8))
            XCTAssertEqual(venue.name, "Surprise Stadium")
            XCTAssertEqual(venue.timezone, "America/Phoenix")
            XCTAssertEqual(venue.state, "AZ")
        } catch {
            XCTFail("Failed: \(error)")
        }
    }
}
