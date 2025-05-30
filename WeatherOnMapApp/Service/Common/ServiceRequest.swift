//
//  ServiceRequest.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import Combine

protocol ServiceRequest {
    func fetchData<T: Decodable>() -> AnyPublisher<[T], RequestError>
}
