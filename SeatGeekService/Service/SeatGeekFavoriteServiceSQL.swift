//
//  SeatGeekFavoriteServiceSQL.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/3/19.
//

import Foundation
import PromiseKit
import SQLite

private enum FavoriteType: String {
    case event
    case venue
    case performer
}

extension FavoriteType: Value {
    public static let declaredDatatype = String.declaredDatatype
    
    public static func fromDatatypeValue(_ datatypeValue: String) -> FavoriteType {
        return FavoriteType(rawValue: datatypeValue)!
    }
    
    public var datatypeValue: String {
        return self.rawValue
    }
}

private struct FavoritesTable {
    let tableName: String = "favorites"
    
    // swiftlint:disable:next identifier_name
    let id = Expression<Int>("id")
    let userId = Expression<UserID>("user_id")
    let identifier = Expression<Int>("identifier")
    let type = Expression<FavoriteType>("favorite_type")
}

public class SeatGeekFavoriteServiceSQL: SeatGeekFavoriteService {
    private static let dbVersion = 1
    
    private var database: Connection
    private let filepath: String?
    private let favoritesTable = FavoritesTable()
    
    public init(filepath: String? = nil) throws {
        self.filepath = filepath
        
        if let path = filepath {
            self.database = try Connection(path)
        } else {
            self.database = try Connection(.inMemory)
        }
        
        self.database.busyTimeout = 5
        self.database.busyHandler({ tries in
            if tries >= 3 {
                return false
            }
            return true
        })
        
        try self.performMigrations()
    }
    
    public func mark(favorite: Bool,
                     event eventId: SeatGeekEventId,
                     for userId: UserID) -> Promise<Void> {
        return firstly { () -> Promise<Void> in
            let table = Table(self.favoritesTable.tableName)
            if favorite {
                let insert = table.insert(self.favoritesTable.userId <- userId,
                                          self.favoritesTable.identifier <- eventId,
                                          self.favoritesTable.type <- .event)
                try self.database.run(insert)
            } else {
                let query = table.filter(userId == self.favoritesTable.userId &&
                                         eventId == self.favoritesTable.identifier &&
                                         .event == self.favoritesTable.type)
                try self.database.run(query.delete())
            }
            
            return Promise()
        }
    }
    
    public func getFavoriteEvents(for userId: UserID) -> Promise<[SeatGeekEventId]> {
        return firstly { () -> Promise<[SeatGeekEventId]> in
            let table = Table(self.favoritesTable.tableName)
            let query = table.filter(userId == self.favoritesTable.userId &&
                                     .event == self.favoritesTable.type)
            let results = try self.database.prepare(query).map { row in
                row[self.favoritesTable.identifier]
            }
            
            return Promise.value(results)
        }
    }
    
    private func performMigrations() throws {
        var userVersion = self.database.userVersion
        while userVersion != SeatGeekFavoriteServiceSQL.dbVersion {
            if userVersion == 0 {
                let table = Table(self.favoritesTable.tableName)
                
                try self.database.run(table.create { builder in
                    builder.column(self.favoritesTable.id, primaryKey: .autoincrement)
                    builder.column(self.favoritesTable.userId)
                    builder.column(self.favoritesTable.identifier)
                    builder.column(self.favoritesTable.type)
                })
            }
            userVersion += 1
        }
        self.database.userVersion = userVersion
    }
}
