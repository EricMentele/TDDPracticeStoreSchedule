//
//  HTTPClient.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/11/24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> Data
}
