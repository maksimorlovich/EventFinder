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
// swiftlint:disable:previous line_length
// TODO: Write a script to convert snake_case to camelCase :)
public enum SeatGeekEventType: String, Codable {
    case addon
    case animalSports = "animal_sports"
    case autoRacing = "auto_racing"
    case baseball
    case basketball
    case boxing
    case broadwayTicketsNational = "broadway_tickets_national"
    case circus
    case cirqueDuSoleil = "cirque_du_soleil"
    case classical
    case classicalOpera = "classical_opera"
    case classicalOrchestralInstrumental = "classical_orchestral_instrumental"
    case classicalVocal = "classical_vocal"
    case clubPasses = "club_passes"
    case comedy
    case concert
    case concerts
    case dancePerformanceTour = "dance_performance_tour"
    case europeanSoccer = "european_soccer"
    case extremeSports = "extreme_sports"
    case formula1 = "f1"
    case family
    case fighting
    case film
    case football
    case golf
    case hockey
    case horseRacing = "horse_racing"
    case indycar
    case internationalSoccer = "international_soccer"
    case literary
    case lpga
    case minorLeagueBaseball = "minor_league_baseball"
    case minorLeagueHockey = "minor_league_hockey"
    case mlb
    case mls
    case mma
    case monsterTruck = "monster_truck"
    case motocross
    case musicFestival = "music_festival"
    case nascar
    case nascarNationwide = "nascar_nationwide"
    case nascarSprintcup = "nascar_sprintcup"
    case nba
    case nbaDleague = "nba_dleague"
    case ncaaBaseball = "ncaa_baseball"
    case ncaaBasketball = "ncaa_basketball"
    case ncaaFootball = "ncaa_football"
    case ncaaHockey = "ncaa_hockey"
    case ncaaSoccer = "ncaa_soccer"
    case ncaaWomensBasketball = "ncaa_womens_basketball"
    case nfl
    case nhl
    case olympicSports = "olympic_sports"
    case parking
    case pga
    case rodeo
    case soccer
    case sports
    case tennis
    case theater
    case usMinorLeagueSoccer = "us_minor_league_soccer"
    case wnba
    case worldCup = "world_cup"
    case wrestling
    case wwe
}

public struct SeatGeekEventStats: Codable {
    public let averagePrice: Double?
    public let lowestPrice: Double?
    public let highestPrice: Double?
}

public struct SeatGeekEvent: Codable {
    public let identifier: SeatGeekEventId
    public let stats: SeatGeekEventStats
    public let title: String
    public let type: SeatGeekEventType
    public let venue: SeatGeekVenue
    public let performers: [SeatGeekPerformer]
    public let url: URL
    public let shortTitle: String
    public let datetimeUtc: Date
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case stats
        case title
        case type
        case venue
        case performers
        case url
        case shortTitle
        case datetimeUtc
    }
}
