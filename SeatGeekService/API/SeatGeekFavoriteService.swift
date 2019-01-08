//
//  SeatGeekFavoriteService.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/3/19.
//

import Foundation
import PromiseKit

public typealias UserID = String

public protocol SeatGeekFavoriteService {
    func mark(favorite: Bool, event eventId: SeatGeekEventId, for userId: UserID) -> Promise<Void>
    func getFavoriteEvents(for userId: UserID) -> Promise<[SeatGeekEventId]>
}
