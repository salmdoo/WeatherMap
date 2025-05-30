//
//  WeatherCacheServiceImp.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 4/16/25.
//

import Combine


struct StationNSCacheServiceImp: StationDataService {
    private let cache = WeatherNSCache()
    
    
    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError> {
        guard let stations = cache.load(date: option) else {
            return Fail(error: RequestError.noData).eraseToAnyPublisher()
        }
        return Just(stations).setFailureType(to: RequestError.self).eraseToAnyPublisher()
    }
    
    func saveMap(dateOption: DateOption, stations: [Station]) -> AnyPublisher<Bool, RequestError> {
        cache.clear(date: dateOption)
        cache.store(date: dateOption, stations: stations)
        return Just(true).setFailureType(to: RequestError.self).eraseToAnyPublisher()
    }
}
