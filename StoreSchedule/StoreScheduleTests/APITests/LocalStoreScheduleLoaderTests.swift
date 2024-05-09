//
//  LocalStoreScheduleLoaderTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/15/24.
//

import XCTest
import StoreSchedule

protocol StoreScheduleLoader {
    func loadStoreSchedule() async throws -> StoreSchedule
}

struct StoreSchedule: Equatable {
    let weekDaysGroupedBySharedHours: [[StoreDaySchedule]]
}

final class LocalStoreScheduleLoader: StoreScheduleLoader {
    let daySchedulesProvider: StoreDayScheduleProvider
    
    func loadStoreSchedule() async throws -> StoreSchedule {
        let daySchedules = try await daySchedulesProvider.getStoreDaySchedules()
        let groups = daySchedules
            .reduce(into: [[StoreDaySchedule]]()) { scheduleGroups, schedule in
                let lastGroupMember = scheduleGroups.last?.last
                let sharesHoursWithCurrentDay = lastGroupMember?.hours == schedule.hours
                
                if sharesHoursWithCurrentDay {
                    var groupSharingHours = scheduleGroups.popLast()
                    groupSharingHours?.append(schedule)
                    scheduleGroups.append(groupSharingHours!)
                } else {
                    scheduleGroups.append([schedule])
                }
            }
        return StoreSchedule(weekDaysGroupedBySharedHours: groups)
    }
    
    init(daySchedulesProvider: StoreDayScheduleProvider = StoreDaySchedulePipeline()) {
        self.daySchedulesProvider = daySchedulesProvider
    }
}

final class LocalStoreScheduleLoaderTests: XCTestCase {
    func test_loadStoreSchedule_returnsStoreSchedule() async throws {
        let provider = StoreDayScheduleProviderMock()
        let sut = LocalStoreScheduleLoader(daySchedulesProvider: provider)
        let expectedSchedule = LocalStoreScheduleLoaderTests.expectedDaySchedules
        
        let schedule = try await sut.loadStoreSchedule()
        
        XCTAssertEqual(schedule, expectedSchedule)
    }
}

extension LocalStoreScheduleLoaderTests {
    struct StoreDayScheduleProviderMock: StoreDayScheduleProvider {
        func getStoreDaySchedules() async throws -> [StoreDaySchedule] {
            return [
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
    }
    
    static let expectedDaySchedules = StoreSchedule(weekDaysGroupedBySharedHours: [
        [
            StoreDaySchedule(
            day: .monday,
            opens: "07:00 AM",
            closes: "11:00 PM"
            ),
            StoreDaySchedule(
            day: .tuesday,
            opens: "07:00 AM",
            closes: "11:00 PM")
        ],
        [
            StoreDaySchedule(
            day: .wednesday,
            opens: "09:00 AM",
            closes: "11:00 PM")
        ],
        [
            StoreDaySchedule(
            day: .thursday,
            opens: "07:00 AM",
            closes: "11:00 PM"),
            StoreDaySchedule(
            day: .friday,
            opens: "07:00 AM",
            closes: "11:00 PM")
        ],
        [
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
    ])
}
