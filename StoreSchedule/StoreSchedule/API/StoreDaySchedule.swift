//
//  StoreDaySchedule.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/14/24.
//

import Foundation

public struct StoreDaySchedule: Equatable {
    public let day: Day
    public let opens: String
    public let closes: String
    
    public init(day: Day, opens: String, closes: String) {
        self.day = day
        self.opens = opens
        self.closes = closes
    }
}

public extension StoreDaySchedule {
    enum Day: String, Equatable {
        case monday = "MONDAY"
        case tuesday = "TUESDAY"
        case wednesday = "WEDNESDAY"
        case thursday = "THURSDAY"
        case friday = "FRIDAY"
        case saturday = "SATURDAY"
        case sunday = "SUNDAY"
    }
}
