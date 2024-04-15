//
//  StoreScheduleViewModelTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/15/24.
//

import XCTest
import StoreSchedule

@Observable
class StoreScheduleViewModel {
    var schedule: String = ""
    
    private let loader: StoreScheduleLoader
    
    func displaySchedule() async throws {
        schedule = try await loader.loadStoreSchedule().weekDaysGroupedBySharedHours.compactMap {
            $0.count > 1 ?
            "\($0.first!.day.displayValue)-\($0.last!.day.displayValue) \($0.first!.displayHours)" :
            "\($0.first!.day.displayValue) \($0.first!.displayHours)"
        }
        .joined(separator: "; ")
    }
    
    init(loader: StoreScheduleLoader) {
        self.loader = loader
    }
}

private extension StoreDaySchedule {
    var displayHours: String {
        let opens = opens.split(separator: " ")
            .map {
                var string = $0
                string.trimPrefix("0")
                if string.count <= 2 {
                    return string.lowercased()
                }
                return "\(string)"
            }.joined()
        
        let closes = closes.split(separator: " ")
            .map {
                var string = $0
                string.trimPrefix("0")
                if string.count <= 2 {
                    return string.lowercased()
                }
                return "\(string)"
            }.joined()
        
        return opens + "-" + closes
    }
}

private extension StoreDaySchedule.Day {
    var displayValue: String {
        "\(self)".titleCase()
    }
}

private extension String {
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
}

final class StoreScheduleViewModelTests: XCTestCase {
    func test_displayStoreSchedule_returnsFormatedStringForStoreSchedule() async throws {
        let loader: StoreScheduleLoader = LocalStoreScheduleLoader()
        let sut = StoreScheduleViewModel(loader: loader)
        let expected = "Monday-Tuesday 7:00am-11:00pm; Wednesday 9:00am-11:00pm; Thursday-Friday 7:00am-11:00pm; Saturday-Sunday 9:00am-11:00pm"
        
        try await sut.displaySchedule()
        
        XCTAssertEqual(sut.schedule, expected)
    }
}
