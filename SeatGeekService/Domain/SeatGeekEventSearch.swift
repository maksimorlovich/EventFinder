//
//  SeatGeekEventSearch.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/2/19.
//

import Foundation

public struct SeatGeekEventSearchResultMetaGeolocation: Codable {
    public let city: String?
    public let displayName: String?
    public let country: String?
    public let longitude: Double
    public let range: String
    public let metroCode: String?
    public let state: String?
    public let postalCode: String?
    public let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case city
        case displayName = "display_name"
        case country
        case longitude = "lon"
        case range
        case metroCode = "metro_code"
        case state
        case postalCode = "postal_code"
        case latitude = "lat"
    }
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
