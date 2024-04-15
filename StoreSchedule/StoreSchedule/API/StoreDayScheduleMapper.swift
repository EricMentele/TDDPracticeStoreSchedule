//
//  StoreDayScheduleMapper.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/15/24.
//

import Foundation

public protocol StoreDayScheduleMapper {
    static func storeDaySchedulesFrom(_ days: [RemoteStoreDaySchedule]) throws -> [StoreDaySchedule]
}

public enum MappingError: Error {
    case invalidDay
}
