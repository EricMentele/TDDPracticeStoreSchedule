//
//  StoreDayScheduleMapper.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/14/24.
//

import Foundation

public protocol StoreDayScheduleMapper {
    static func storeDaySchedulesFrom(_ days: [RemoteStoreDaySchedule]) throws -> [StoreDaySchedule]
}

public enum MappingError: Error {
    case invalidDay
}

public final class RemoteStoreDayScheduleMapper: StoreDayScheduleMapper {
    public static func storeDaySchedulesFrom(_ days: [RemoteStoreDaySchedule]) throws -> [StoreDaySchedule] {
        try days.map(scheduleFrom)
    }
    
    private static func scheduleFrom(_ schedule: RemoteStoreDaySchedule) throws -> StoreDaySchedule {
        guard let day = StoreDaySchedule.Day(rawValue: schedule.day) else { throw MappingError.invalidDay }
        
        return StoreDaySchedule(
            day: day,
            opens: schedule.opens,
            closes: schedule.closes
        )
    }
}
