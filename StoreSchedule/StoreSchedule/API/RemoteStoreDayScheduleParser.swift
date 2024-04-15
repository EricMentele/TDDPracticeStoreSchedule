//
//  RemoteStoreDayScheduleParser.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/13/24.
//

import Foundation

public protocol StoreDayScheduleParser {
    static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule]
}

public typealias RemoteStoreDaySchedule = RemoteStoreDayScheduleParser.RemoteStoreDaySchedule

public enum ParsingError: Error {
    case invalidData
}

public final class RemoteStoreDayScheduleParser: StoreDayScheduleParser {
    public struct RemoteStoreDaySchedule: Decodable {
        public let day: String
        public let opens: String
        public let closes: String
    }
    
    public static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
        guard let daySchedules = try? JSONDecoder().decode([RemoteStoreDaySchedule].self, from: data) else { throw ParsingError.invalidData }
        return daySchedules
    }
}
