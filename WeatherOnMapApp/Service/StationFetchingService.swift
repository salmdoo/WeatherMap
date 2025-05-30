//
//  StationService.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import Combine

enum RequestError: Error {
    case invalidURL
    case noData
    case badServerResponse
    case others(_ error: Error)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .noData:
            return "No data was returned from the request"
        case .badServerResponse:
            return "Bad Server Response"
        case .others(let error):
            return error.localizedDescription
        }
        
    }
}

protocol StationFetchingService {
    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError>
}

protocol StationSavingService {
    func saveMap(dateOption: DateOption,stations: [Station]) -> AnyPublisher<Bool, RequestError>
}

typealias StationDataService = StationFetchingService & StationSavingService


