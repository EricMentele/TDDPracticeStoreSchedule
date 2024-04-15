//
//  PlaceholderHTTPClient.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/11/24.
//

import Foundation

public final class HTTPClientPlaceholder: HTTPClient {
    public let jsonString: String
    
    public func get(from url: URL) async throws -> Data {
        guard let data = jsonString.data(using: .utf8) else { throw HTTPClientError.connectivity }
        return data
    }
    
    public init(jsonString: String = mockScheduleJson) {
        self.jsonString = jsonString
    }
}

public enum HTTPClientError: Error {
    case connectivity
}

extension HTTPClientPlaceholder {
    public static let mockScheduleJson =
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
