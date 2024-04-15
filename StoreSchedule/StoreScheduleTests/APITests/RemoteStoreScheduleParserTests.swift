//
//  RemoteStoreScheduleParserTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/13/24.
//

import XCTest
import StoreSchedule

final class RemoteStoreScheduleParserTests: XCTestCase {
    func test_remoteStoreDaySchedulesFromData_returnsRemoteStoreDaySchedules() throws {
        let data = RemoteStoreScheduleParserTests.mockScheduleJsonData
        
        let storeDaySchedules = try RemoteStoreDayScheduleParser.remoteStoreDaySchedulesFrom(data)
        
        XCTAssertNotNil(storeDaySchedules)
        XCTAssertFalse(storeDaySchedules.isEmpty)
    }
    
    func test_remoteStoreDaySchedulesFromData_returnsErrorOnInvalidData() throws {
        let data = Data()
        
        XCTAssertThrowsError(
            try RemoteStoreDayScheduleParser.remoteStoreDaySchedulesFrom(data)
        )
    }
}

private extension RemoteStoreScheduleParserTests {
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
