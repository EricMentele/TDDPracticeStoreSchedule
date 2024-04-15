//
//  StoreDaySchedulePipeline.swift
//  StoreSchedule
//
//  Created by Eric Mentele on 4/15/24.
//

import Foundation

public final class StoreDaySchedulePipeline: StoreDayScheduleProvider {
    private let api: HTTPClient
    private let parser: StoreDayScheduleParser.Type
    private let mapper: StoreDayScheduleMapper.Type
    
    public func getStoreDaySchedules() async throws -> [StoreDaySchedule] {
        let data = try await api.get(from: URL(string: "Placeholder url")!)
        let remoteSchedules = try parser.remoteStoreDaySchedulesFrom(data)
        return try mapper.storeDaySchedulesFrom(remoteSchedules)
    }
    
    public init(
        api: HTTPClient = HTTPClientPlaceholder(),
        parser: StoreDayScheduleParser.Type = RemoteStoreDayScheduleParser.self,
        mapper: StoreDayScheduleMapper.Type = RemoteStoreDayScheduleMapper.self
    ) {
            self.api = api
            self.parser = parser
            self.mapper = mapper
    }
}
