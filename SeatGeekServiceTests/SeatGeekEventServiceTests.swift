//
//  SeatGeekEventServiceTests.swift
//  SeatGeekServiceTests
//
//  Created by Maksim Orlovich on 1/2/19.
//

import XCTest
@testable import SeatGeekService

class SeatGeekEventServiceTests: XCTestCase {
    private let eventsService: SeatGeekEventService =
        SeatGeekEventServiceLive(clientId: "MTQyNTcxNjN8MTU0NDA2NTkyNi42")
    
    func testSearchTexasRangers() {
        let expect = expectation(description: "Search")
        self.eventsService.search(events: "Texas Rangers", perPage: 5000, page: 1)
            .done { result in
                XCTAssert(result.events.count != 0)
            }
            .catch {
                XCTFail("Failed: \($0)")
            }
            .finally {
                expect.fulfill()
            }
        
        waitForExpectations(timeout: 10)
    }
    
    func testDetails() {
        // TODO: Eventually this event will expire and test will fail. Consider replacing with mock data.
        let identifier = 4608480
        let expect = expectation(description: "Details")
        self.eventsService.details(for: identifier)
            .done { result in
                XCTAssertEqual(result.identifier, identifier)
                XCTAssertEqual(result.type, .mlb)
                XCTAssertEqual(result.title, "Spring Training: Texas Rangers at Los Angeles Dodgers")
                XCTAssertEqual(result.shortTitle, "Spring Training: Rangers at Dodgers")
            }
            .catch {
                XCTFail("Failed: \($0)")
            }
            .finally {
                expect.fulfill()
            }
        
        waitForExpectations(timeout: 2)
    }
}
