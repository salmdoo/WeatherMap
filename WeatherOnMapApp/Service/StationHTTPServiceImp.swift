//
//  StationHTTPServiceImp.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import Combine

struct APIEndpoint {
    private static let domain = "https://gist.githubusercontent.com/rcedwards"
    static let weatherToday = "\(domain)/4ff0a1510551295be0ec0369186d83ed/raw/fc7b5308546c0e1085d8748134138cef4281ac11/today.json"
    static let weatherTomorrow = "\(domain)/6421fa7f0f3789801935d6d37df55922/raw/e673021836819aa20018853643c8769fd4d129fd/tomorrow.json"
}

// MARK: - Station HTTP Service Implementation

struct StationHTTPServiceImp: StationFetchingService {
    
    private var serviceRequest: ServiceRequest
    
    init(serviceRequest: ServiceRequest) {
        self.serviceRequest = serviceRequest
    }
    
    private func url (for mapOption: DateOption) -> String {
        switch mapOption {
        case .today:
            return APIEndpoint.weatherToday
        case .tomorrow:
            return APIEndpoint.weatherTomorrow
        }
    }
    
    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError> {
        guard var httpService = serviceRequest as? HTTPServiceRequestImp else {
            return Fail(error: RequestError.badServerResponse).eraseToAnyPublisher() }
        
        httpService.url = url(for: option)
        return httpService.fetchData()
    }
}
