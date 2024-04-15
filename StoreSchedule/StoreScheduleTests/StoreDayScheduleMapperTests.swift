//
//  StoreDayScheduleMapperTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/14/24.
//

import XCTest
import StoreSchedule

final class StoreDayScheduleMapperTests: XCTestCase {
    func test_storeDaySchedulesFrom_createsStoreDaySchedulesFromRemoteModel() throws {
        let remoteSchedules = try RemoteStoreDayScheduleParser.remoteStoreDaySchedulesFrom(StoreDayScheduleMapperTests.mockScheduleJsonData)
        let expected = StoreDayScheduleMapperTests.expectedDaySchedules
        
        let schedules = try! StoreDayScheduleMapper.storeDaySchedulesFrom(remoteSchedules)
        
        XCTAssertEqual(schedules, expected)
    }
    
    func test_storeDayScheduleFrom_throwsAnErrorForUnrecognizedDayValue() throws {
        let remoteSchedules = try RemoteStoreDayScheduleParser.remoteStoreDaySchedulesFrom(StoreDayScheduleMapperTests.mockScheduleJsonDataUnrecognizedDay)
        
        XCTAssertThrowsError(try StoreDayScheduleMapper.storeDaySchedulesFrom(remoteSchedules))
    }
}

extension StoreDayScheduleMapperTests {
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
        )
        ,StoreDaySchedule(
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
