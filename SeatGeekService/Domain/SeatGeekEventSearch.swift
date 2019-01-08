//
//  SeatGeekEventSearch.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/2/19.
//

import Foundation

public struct SeatGeekEventSearchResultMetaGeolocation: Codable {
    public let city: String?
    public let display_name: String?
    public let country: String?
    public let lon: Double
    public let range: String
    public let metro_code: String?
    public let state: String?
    public let postal_code: String?
    public let lat: Double
}

public struct SeatGeekEventSearchResultMeta: Codable {
    public let geolocation: SeatGeekEventSearchResultMetaGeolocation?
    public let perPage: Int
    public let total: Int
    public let page: Int
}

public struct SeatGeekEventSearchResult: Codable {
    public let meta: SeatGeekEventSearchResultMeta
    public let events: [SeatGeekEvent]
}
