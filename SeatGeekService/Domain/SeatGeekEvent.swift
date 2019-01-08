//
//  SeatGeekEvent.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/2/19.
//

import Foundation

public typealias SeatGeekEventId = Int

// Generated using this command:
// curl -s -X GET 'https://api.seatgeek.com/2/taxonomies?client_id=MTQyNTcxNjN8MTU0NDA2NTkyNi42' | python -mjson.tool | grep "slug" | cut -f 4 -d "\"" | sort
// TODO: Write a script to convert snake_case to camelCase :)
public enum SeatGeekEventType: String, Codable {
    case addon
    case animal_sports
    case auto_racing
    case baseball
    case basketball
    case boxing
    case broadway_tickets_national
    case circus
    case cirque_du_soleil
    case classical
    case classical_opera
    case classical_orchestral_instrumental
    case classical_vocal
    case club_passes
    case comedy
    case concert
    case concerts
    case dance_performance_tour
    case european_soccer
    case extreme_sports
    case f1
    case family
    case fighting
    case film
    case football
    case golf
    case hockey
    case horse_racing
    case indycar
    case international_soccer
    case literary
    case lpga
    case minor_league_baseball
    case minor_league_hockey
    case mlb
    case mls
    case mma
    case monster_truck
    case motocross
    case music_festival
    case nascar
    case nascar_nationwide
    case nascar_sprintcup
    case nba
    case nba_dleague
    case ncaa_baseball
    case ncaa_basketball
    case ncaa_football
    case ncaa_hockey
    case ncaa_soccer
    case ncaa_womens_basketball
    case nfl
    case nhl
    case olympic_sports
    case parking
    case pga
    case rodeo
    case soccer
    case sports
    case tennis
    case theater
    case us_minor_league_soccer
    case wnba
    case world_cup
    case wrestling
    case wwe
}

public struct SeatGeekEventStats: Codable {
    public let averagePrice: Double?
    public let lowestPrice: Double?
    public let highestPrice: Double?
}

public struct SeatGeekEvent: Codable {
    public let id: SeatGeekEventId
    public let stats: SeatGeekEventStats
    public let title: String
    public let type: SeatGeekEventType
    public let venue: SeatGeekVenue
    public let performers: [SeatGeekPerformer]
    public let url: URL
    public let shortTitle: String
    public let datetimeUtc: Date
}
