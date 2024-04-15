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

public final class RemoteStoreDayScheduleParser: StoreDayScheduleParser {
    public struct RemoteStoreDaySchedule: Decodable {
        public let day: String
        public let opens: String
        public let closes: String
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
        guard let daySchedules = try? JSONDecoder().decode([RemoteStoreDaySchedule].self, from: data) else { throw Error.invalidData }
        return daySchedules
    }
}
