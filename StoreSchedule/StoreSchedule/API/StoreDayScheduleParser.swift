//
//  StoreDayScheduleParser.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/15/24.
//

import Foundation

public protocol StoreDayScheduleParser {
    static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule]
}

public enum ParsingError: Error {
    case invalidData
}
