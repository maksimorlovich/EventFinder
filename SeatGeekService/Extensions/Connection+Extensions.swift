//
//  Connection+Extensions.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/3/19.
//

import Foundation
import SQLite

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
