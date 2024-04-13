//
//  StoreScheduleTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/11/24.
//

import XCTest
import StoreSchedule

struct RemoteStoreDaySchedule: Decodable {
    let day: String
    let opens: String
    let closes: String
}

private final class StoreDayScheduleParser {
    static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
        return try! JSONDecoder().decode([RemoteStoreDaySchedule].self, from: data)
    }
}

final class StoreScheduleTests: XCTestCase {
    func test_remoteStoreDaySchedulesFromData_returnsRemoteStoreDaySchedules() {
        let data = StoreScheduleTests.mockScheduleJsonData
        
        let storeDaySchedules = try? StoreDayScheduleParser.remoteStoreDaySchedulesFrom(data)
        
        XCTAssertNotNil(storeDaySchedules)
        XCTAssertFalse(storeDaySchedules!.isEmpty)
    }
}

private extension StoreScheduleTests {
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
}
