//
//  DateFormatter+Extensions.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/5/19.
//

import Foundation

extension DateFormatter {
    static let searchEventsFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
}
