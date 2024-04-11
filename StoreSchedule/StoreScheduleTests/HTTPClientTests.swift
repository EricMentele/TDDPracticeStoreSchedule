//
//  HTTPClientTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/11/24.
//

import XCTest
import Foundation
import StoreSchedule

final class HTTPClientTests: XCTestCase {
    func test_getFromURL_ReturnsData() async {
        let sut = HTTPClientPlaceholder()
        let url = URL(string: "fake store schedule placeholder")!
        
        let result = await sut.get(from: url)
        
        XCTAssertNotNil(try? result.get())
    }
}
