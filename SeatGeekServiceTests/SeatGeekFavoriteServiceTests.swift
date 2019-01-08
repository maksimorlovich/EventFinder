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
        let favoriteService: SeatGeekFavoriteService = try! SeatGeekFavoriteServiceSQL()
        
        let ex = expectation(description: "Get favorite events")
        let _ = favoriteService.getFavoriteEvents(for: self.maksimUserId)
            .done { favorites in
                XCTAssertEqual(favorites.count, 0)
            }
            .catch { error in
                XCTFail("Unexpected error: \(error)")
            }
            .finally {
                ex.fulfill()
            }
        
        waitForExpectations(timeout: 2)
    }
    
    func testAddThenFindFavoriteEvent() {
        let favoriteService: SeatGeekFavoriteService = try! SeatGeekFavoriteServiceSQL()
        
        let ex = expectation(description: "Add then find favorite event")
        let _ = favoriteService.mark(favorite: true, event: 12345, for: self.maksimUserId)
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
                ex.fulfill()
            }
        
        waitForExpectations(timeout: 2)
    }
}
