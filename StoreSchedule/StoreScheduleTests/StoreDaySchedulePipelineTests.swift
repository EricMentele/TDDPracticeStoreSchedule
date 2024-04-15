//
//  StoreScheduleTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/11/24.
//

import XCTest
import StoreSchedule

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
    
    func test_getStoreDaySchedules_returnsMappingErrorOnMappingFailure() async throws {
        let sut = sutPassing(mapper: false)
        let expectedError = MappingError.invalidDay
        
        var thrownError: Error?
        do {
            let _ = try await sut.getStoreDaySchedules()
        } catch {
            thrownError = expectedError
        }
        
        XCTAssertEqual(thrownError as? MappingError, expectedError)
    }
}

private extension StoreDaySchedulePipelineTests {
    func sutPassing(httpClient: Bool = true, parser: Bool = true, mapper: Bool = true) -> StoreDayScheduleProvider {
        StoreDaySchedulePipeline(
            api: httpClient ? HTTPClientMock.Succeeds() : HTTPClientMock.Fails(),
            parser: parser ? ParserMock.Succeeds.self : ParserMock.Fails.self,
            mapper: mapper ? MapperMock.Succeeds.self : MapperMock.Fails.self
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
            static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
                []
            }
        }
        
        final class Fails: StoreDayScheduleParser {
            static func remoteStoreDaySchedulesFrom(_ data: Data) throws -> [RemoteStoreDaySchedule] {
                throw ParsingError.invalidData
            }
        }
    }
    
    struct MapperMock {
        final class Succeeds: StoreDayScheduleMapper {
            static func storeDaySchedulesFrom(_ days: [RemoteStoreDaySchedule]) throws -> [StoreDaySchedule] {
                expectedDaySchedules
            }
        }
        
        final class Fails: StoreDayScheduleMapper {
            static func storeDaySchedulesFrom(_ days: [RemoteStoreDaySchedule]) throws -> [StoreDaySchedule] {
                throw MappingError.invalidDay
            }
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
