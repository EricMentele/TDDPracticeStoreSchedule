//
//  StoreDayScheduleMapper.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/14/24.
//

import Foundation

public final class StoreDayScheduleMapper {
    public enum Error: Swift.Error {
        case invalidDayMapping
    }
    
    public static func storeDaySchedulesFrom(_ days: [RemoteStoreDaySchedule]) throws -> [StoreDaySchedule] {
        try days.map(scheduleFrom)
    }
    
    private static func scheduleFrom(_ schedule: RemoteStoreDaySchedule) throws -> StoreDaySchedule {
        guard let day = StoreDaySchedule.Day(rawValue: schedule.day) else { throw Error.invalidDayMapping }
        
        return StoreDaySchedule(
            day: day,
            opens: schedule.opens,
            closes: schedule.closes
        )
    }
}
