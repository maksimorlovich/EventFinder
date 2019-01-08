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
        let ex = expectation(description: "Search")
        let _ = self.eventsService.search(events: "Texas Rangers", perPage: 5000, page: 1)
            .done { result in
                XCTAssert(result.events.count != 0)
            }
            .catch {
                XCTFail("Failed: \($0)")
            }
            .finally {
                ex.fulfill()
            }
        
        waitForExpectations(timeout: 10)
    }
    
    func testDetails() {
        // TODO: Eventually this event will expire and test will fail. Consider replacing with mock data.
        let id = 4608480
        let ex = expectation(description: "Details")
        let _ = self.eventsService.details(for: id)
            .done { result in
                XCTAssertEqual(result.id, id)
                XCTAssertEqual(result.type, .mlb)
                XCTAssertEqual(result.title, "Spring Training: Texas Rangers at Los Angeles Dodgers")
                XCTAssertEqual(result.shortTitle, "Spring Training: Rangers at Dodgers")
            }
            .catch {
                XCTFail("Failed: \($0)")
            }
            .finally {
                ex.fulfill()
            }
        
        waitForExpectations(timeout: 2)
    }
}
