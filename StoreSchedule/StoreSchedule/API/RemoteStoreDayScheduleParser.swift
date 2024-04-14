//
//  RemoteStoreDayScheduleParser.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/13/24.
//

import Foundation

public final class RemoteStoreDayScheduleParser {
    public struct RemoteStoreDaySchedule: Decodable {
        let day: String
        let opens: String
        let closes: String
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
        guard let daySchedules = try? JSONDecoder().decode([RemoteStoreDaySchedule].self, from: data) else { throw Error.invalidData }
        return daySchedules
    }
}
