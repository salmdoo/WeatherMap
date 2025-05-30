//
//  MockService.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 3/30/25.
//
import Combine
@testable import WeatherOnMapApp

class MockServiceImp: StationFetchingService {
    var result: AnyPublisher<[Station], RequestError> = Just([])
        .setFailureType(to: RequestError.self)
        .eraseToAnyPublisher()

    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError> {
        return result
    }
}
