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
        let sut: HTTPClient = HTTPClientPlaceholder()
        
        let data = try? await sut.get(from: URL(string: "placeholder fake url")!)
        
        XCTAssertNotNil(data)
    }
}
