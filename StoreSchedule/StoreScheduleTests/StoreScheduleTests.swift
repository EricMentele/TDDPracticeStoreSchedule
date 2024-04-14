//
//  StoreScheduleTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/11/24.
//

import XCTest
import StoreSchedule

public struct StoreDaySchedule: Equatable {
    let day: Day
    let opens: String
    let closes: String
    
    enum Day: String {
        case monday = "MONDAY"
        case tuesday = "TUESDAY"
        case wednesday = "WEDNESDAY"
        case thursday = "THURSDAY"
        case friday = "FRIDAY"
        case saturday = "SATURDAY"
        case sunday = "SUNDAY"
    }
}

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

final class StoreScheduleTests: XCTestCase {
    func test_storeDaySchedulesFrom_createsStoreDaySchedulesFromRemoteModel() throws {
        let remoteSchedules = try RemoteStoreDayScheduleParser.remoteStoreDaySchedulesFrom(StoreScheduleTests.mockScheduleJsonData)
        let expected = StoreScheduleTests.expectedDaySchedules
        
        let schedules = try! StoreDayScheduleMapper.storeDaySchedulesFrom(remoteSchedules)
        
        XCTAssertEqual(schedules, expected)
    }
    
    func test_storeDayScheduleFrom_throwsAnErrorForUnrecognizedDayValue() throws {
        let remoteSchedules = try RemoteStoreDayScheduleParser.remoteStoreDaySchedulesFrom(StoreScheduleTests.mockScheduleJsonDataUnrecognizedDay)
        
        XCTAssertThrowsError(try StoreDayScheduleMapper.storeDaySchedulesFrom(remoteSchedules))
    }
}

private extension StoreScheduleTests {
    static let expectedDaySchedules = [
        StoreDaySchedule(
            day: .monday,
            opens: "07:00 AM",
            closes: "11:00 PM"
        ),
        StoreDaySchedule(
            day: .tuesday,
            opens: "07:00 AM",
            closes: "11:00 PM"
        ),
        StoreDaySchedule(
            day: .wednesday,
            opens: "09:00 AM",
            closes: "11:00 PM"
        ),
        StoreDaySchedule(
            day: .thursday,
            opens: "07:00 AM",
            closes: "11:00 PM"
        ),
        StoreDaySchedule(
            day: .friday,
            opens: "07:00 AM",
            closes: "11:00 PM"
        ),
        StoreDaySchedule(
            day: .saturday,
            opens: "09:00 AM",
            closes: "11:00 PM"
        ),StoreDaySchedule(
            day: .sunday,
            opens: "09:00 AM",
            closes: "11:00 PM"
        )
    ]
    static let mockScheduleJsonData =
    """
    [
        {
            "day": "MONDAY",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "TUESDAY",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "WEDNESDAY",
            "opens": "09:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "THURSDAY",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "FRIDAY",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "SATURDAY",
            "opens": "09:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "SUNDAY",
            "opens": "09:00 AM",
            "closes": "11:00 PM"
        }
    ]
    """.data(using: .utf8)!
    
    static let mockScheduleJsonDataUnrecognizedDay =
    """
    [
        {
            "day": "monday",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "flip",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "flop",
            "opens": "09:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "THURSDAY",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "FRIDAY",
            "opens": "07:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "SATURDAY",
            "opens": "09:00 AM",
            "closes": "11:00 PM"
        },
        {
            "day": "SUNDAY",
            "opens": "09:00 AM",
            "closes": "11:00 PM"
        }
    ]
    """.data(using: .utf8)!
}
