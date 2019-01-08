//
//  SeatGeekEventService.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/3/19.
//

import Foundation
import PromiseKit

public enum SeatGeekEventSearchCriteria {
    case query(String)
    case ids([SeatGeekEventId])
    case location(latitude: Double, longitude: Double)
    case venue(SeatGeekVenueId)
    case performer(SeatGeekPerformerId)
}

public protocol SeatGeekEventService {
    func details(for eventId: SeatGeekEventId) -> Promise<SeatGeekEvent>
    func search(events query: String, perPage: Int, page: Int) -> Promise<SeatGeekEventSearchResult>
    func search(by criteria: SeatGeekEventSearchCriteria,
                perPage: Int,
                page: Int) -> Promise<SeatGeekEventSearchResult>
}
