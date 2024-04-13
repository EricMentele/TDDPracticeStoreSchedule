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

final class StoreDayScheduleParser {
    static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
        guard let daySchedules = try? JSONDecoder().decode([RemoteStoreDaySchedule].self, from: data) else { throw Error.invalidData }
        return daySchedules
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
}

final class StoreScheduleTests: XCTestCase {
    func test_remoteStoreDaySchedulesFromData_returnsRemoteStoreDaySchedules() {
        let data = StoreScheduleTests.mockScheduleJsonData
        
        let storeDaySchedules = try? StoreDayScheduleParser.remoteStoreDaySchedulesFrom(data)
        
        XCTAssertNotNil(storeDaySchedules)
        XCTAssertFalse(storeDaySchedules!.isEmpty)
    }
    
    func test_remoteStoreDaySchedulesFromData_returnsErrorOnInvalidData() {
        let data = Data()
        
        var error: Error?
        
        do {
            let storeDaySchedules = try StoreDayScheduleParser.remoteStoreDaySchedulesFrom(data)
        } catch let invalidDataError {
            error = invalidDataError
        }
        
        XCTAssertNotNil(error)
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
