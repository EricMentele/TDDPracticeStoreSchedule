//
//  StoreScheduleTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/11/24.
//

import XCTest
import StoreSchedule

public protocol StoreDayScheduleProvider {
    func getStoreDaySchedules() async throws -> [StoreDaySchedule]
}

public final class StoreDaySchedulePipeline: StoreDayScheduleProvider {
    private let api: HTTPClient
    private let parser: StoreDayScheduleParser.Type
    private let mapper: StoreDayScheduleMapper.Type
    
    public func getStoreDaySchedules() async throws -> [StoreDaySchedule] {
        let data = try await api.get(from: URL(string: "Placeholder url")!)
        let remoteSchedules = try parser.remoteStoreDaySchedulesFrom(data)
        return try mapper.storeDaySchedulesFrom(remoteSchedules)
    }
    
    init(
        api: HTTPClient = HTTPClientPlaceholder(),
        parser: StoreDayScheduleParser.Type = RemoteStoreDayScheduleParser.self,
        mapper: StoreDayScheduleMapper.Type = RemoteStoreDayScheduleMapper.self) {
            self.api = api
            self.parser = parser
            self.mapper = mapper
        }
}

final class StoreDaySchedulePipelineTests: XCTestCase {
    func test_getStoreDaySchedules_returnsStoreDaySchedules() async throws {
        let sut = sutAllPassing()
        let exptectedSchedules = StoreDaySchedulePipelineTests.expectedDaySchedules
        
        let daySchedules = try await sut.getStoreDaySchedules()
        
        XCTAssertEqual(daySchedules, exptectedSchedules)
    }
}

private extension StoreDaySchedulePipelineTests {
    func sutAllPassing() -> StoreDayScheduleProvider {
        StoreDaySchedulePipeline(
            api: APIMock(),
            parser: ParserMock.self,
            mapper: MapperMock.self
        )
    }
    
    struct APIMock: HTTPClient {
        func get(from url: URL) async throws -> Data {
            Data()
        }
    }
    
    final class ParserMock: StoreDayScheduleParser {
        static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [StoreSchedule.RemoteStoreDaySchedule] {
            []
        }
    }
    
    final class MapperMock: StoreDayScheduleMapper {
        static func storeDaySchedulesFrom(_ days: [StoreSchedule.RemoteStoreDaySchedule]) throws -> [StoreSchedule.StoreDaySchedule] {
            expectedDaySchedules
        }
    }
    
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
}
