//
//  HTTPClientTests.swift
//  StoreScheduleTests
//
//  Created by Eric Mentele on 4/11/24.
//

import XCTest
import Foundation
import StoreSchedule

protocol HTTPClient {
    typealias Result = Swift.Result<Data, Error>
    
    func get(from url: URL) async -> Result
}

final class HTTPClientTests: XCTestCase {
    func test_getFromURL_ReturnsData() async {
        let sut = HTTPClientPlaceholder()
        let url = URL(string: "fake store schedule placeholder")!
        
        let result = await sut.get(from: url)
        
        XCTAssertNotNil(try? result.get())
    }
}

final class HTTPClientPlaceholder: HTTPClient {
    let jsonString: String
    
    func get(from url: URL) async -> HTTPClient.Result {
        guard let data = jsonString.data(using: .utf8) else { return .failure(Error.invalidDataString) }
        return .success(data)
    }
    
    init(jsonString: String = mockScheduleJson) {
        self.jsonString = jsonString
    }
}

extension HTTPClientPlaceholder {
    enum Error: Swift.Error {
        case invalidDataString
    }
}

var mockScheduleJson: String {
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
    """
}
