//
//  SeatGeekPerformer.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/4/19.
//

import Foundation

public typealias SeatGeekPerformerId = Int

public struct SeatGeekPerformer: Codable {
    public let image: URL?
    public let primary: Bool?
    public let id: SeatGeekPerformerId
    public let shortName: String
    public let homeVenueId: SeatGeekVenueId?
    public let name: String
}
