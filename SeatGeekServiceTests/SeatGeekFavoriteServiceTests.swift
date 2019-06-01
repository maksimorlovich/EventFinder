//
//  SeatGeekFavoriteServiceTests.swift
//  SeatGeekServiceTests
//
//  Created by Maksim Orlovich on 1/3/19.
//

import XCTest
@testable import SeatGeekService

class SeatGeekFavoriteServiceTests: XCTestCase {
    private let maksimUserId: UserID = "maksim.orlovich"
    
    func testGetFavoriteEventsEmptyDB() {
        guard let favoriteService: SeatGeekFavoriteService = try? SeatGeekFavoriteServiceSQL() else {
            XCTFail("Failed to instantiate SeatGeekFavoriteServiceSQL")
            return
        }
        
        let expect = expectation(description: "Get favorite events")
        favoriteService.getFavoriteEvents(for: self.maksimUserId)
            .done { favorites in
                XCTAssertEqual(favorites.count, 0)
            }
            .catch { error in
                XCTFail("Unexpected error: \(error)")
            }
            .finally {
                expect.fulfill()
            }
        
        waitForExpectations(timeout: 2)
    }
    
    func testAddThenFindFavoriteEvent() {
        guard let favoriteService: SeatGeekFavoriteService = try? SeatGeekFavoriteServiceSQL() else {
            XCTFail("Failed to instantiate SeatGeekFavoriteServiceSQL")
            return
        }
        
        let expect = expectation(description: "Add then find favorite event")
        favoriteService.mark(favorite: true, event: 12345, for: self.maksimUserId)
            .then {
                favoriteService.getFavoriteEvents(for: self.maksimUserId)
            }
            .done { favorites in
                guard let favorite = favorites.first else {
                    XCTFail("Failed to find favorited event")
                    return
                }
                XCTAssertEqual(favorites.count, 1)
                XCTAssertEqual(favorite, 12345)
            }
            .catch { error in
                XCTFail("Unexpected error: \(error)")
            }
            .finally {
                expect.fulfill()
            }
        
        waitForExpectations(timeout: 2)
    }
}
