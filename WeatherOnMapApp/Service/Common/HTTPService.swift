//
//  HTTPServiceRequestImp.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import Foundation
import Combine

struct HTTPServiceRequestImp: ServiceRequest {
    private var urlSession: URLSession
    var url: String
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.url = ""
    }
    
    func fetchData<T>() -> AnyPublisher<[T], RequestError> where T : Decodable {
        guard let url =  URL(string: url) else {
            return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
         
        return urlSession.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap{ data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw RequestError.badServerResponse
                }
                return data
            }
            .decode(type: [T].self, decoder: JSONDecoder())
            .mapError { error in
                RequestError.others(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
