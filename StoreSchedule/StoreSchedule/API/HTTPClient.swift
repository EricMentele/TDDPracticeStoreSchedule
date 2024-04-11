//
//  HTTPClient.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/11/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<Data, Error>
    
    func get(from url: URL) async -> Result
}
