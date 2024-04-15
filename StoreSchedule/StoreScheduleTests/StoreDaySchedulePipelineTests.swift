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
        let sut = sutPassing()
        let exptectedSchedules = StoreDaySchedulePipelineTests.expectedDaySchedules
        
        let daySchedules = try await sut.getStoreDaySchedules()
        
        XCTAssertEqual(daySchedules, exptectedSchedules)
    }
    
    func test_getStoreDaySchedules_returnsHTTPClientErrorOnHTTPClientFailure() async throws {
        let sut = sutPassing(httpClient: false)
        let expectedError = HTTPClientError.connectivity
        
        var thrownError: Error?
        do {
            let _ = try await sut.getStoreDaySchedules()
        } catch {
            thrownError = expectedError
        }
        
        XCTAssertEqual(thrownError as? HTTPClientError, expectedError)
    }
    
    func test_getStoreDaySchedules_returnsParsingErrorOnParsingFailure() async throws {
        let sut = sutPassing(parser: false)
        let expectedError = ParsingError.invalidData
        
        var thrownError: Error?
        do {
            let _ = try await sut.getStoreDaySchedules()
        } catch {
            thrownError = expectedError
        }
        
        XCTAssertEqual(thrownError as? ParsingError, expectedError)
    }
}

private extension StoreDaySchedulePipelineTests {
    func sutPassing(httpClient: Bool = true, parser: Bool = true, mapper: Bool = true) -> StoreDayScheduleProvider {
        StoreDaySchedulePipeline(
            api: httpClient ? HTTPClientMock.Succeeds() : HTTPClientMock.Fails(),
            parser: parser ? ParserMock.Succeeds.self : ParserMock.Fails.self,
            mapper: MapperMock.self
        )
    }
    
    struct HTTPClientMock {
        struct Succeeds: HTTPClient {
            func get(from url: URL) async throws -> Data {
                Data()
            }
        }
        
        struct Fails: HTTPClient {
            func get(from url: URL) async throws -> Data {
                throw HTTPClientError.connectivity
            }
        }
    }
    
    struct ParserMock {
        final class Succeeds: StoreDayScheduleParser {
            static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [StoreSchedule.RemoteStoreDaySchedule] {
                []
            }
        }
        
        final class Fails: StoreDayScheduleParser {
            static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [StoreSchedule.RemoteStoreDaySchedule] {
                throw ParsingError.invalidData
            }
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
