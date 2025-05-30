//
//  StationCacheServiceImp.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 4/16/25.
//


import Combine

struct StationCacheServiceImp: StationDataService {
    
    private let cacheManager = WeatherCache()
    
    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError> {
        guard let stations = cacheManager.load(for: option) else {
            return Fail(error: RequestError.noData).eraseToAnyPublisher()
        }
        return Just(stations).setFailureType(to: RequestError.self).eraseToAnyPublisher()
    }
    
    func saveMap(dateOption: DateOption, stations: [Station]) -> AnyPublisher<Bool, RequestError> {
        cacheManager.store(for: dateOption, stations)
        return Just(true).setFailureType(to: RequestError.self).eraseToAnyPublisher()
    }
    
    
}
