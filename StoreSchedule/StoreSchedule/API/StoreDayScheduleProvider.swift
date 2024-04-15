//
//  StoreDayScheduleProvider.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/15/24.
//

import Foundation

public protocol StoreDayScheduleProvider {
    func getStoreDaySchedules() async throws -> [StoreDaySchedule]
}
