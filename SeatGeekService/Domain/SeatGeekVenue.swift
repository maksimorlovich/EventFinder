//
//  SeatGeekVenue.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/2/19.
//

import Foundation

public typealias SeatGeekVenueId = Int

public struct SeatGeekLocation: Codable {
    public let latitude: Double
    public let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

public struct SeatGeekVenue: Codable {
    public let metroCode: Int
    public let postalCode: String
    public let timezone: String?
    public let hasUpcomingEvents: Bool
    public let id: SeatGeekVenueId
    public let city: String
    public let extendedAddress: String
    public let displayLocation: String
    public let state: String
    public let score: Double
    public let location: SeatGeekLocation
    public let address: String
    public let slug: String
    public let name: String
    public let url: URL
    public let country: String
}
