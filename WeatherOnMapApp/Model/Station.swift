//
//  StationModel.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import CoreLocation

struct Station: Identifiable, Decodable, Equatable {
    let id: String
    let name: String?
    let longitude: Double?
    let latitude: Double?
    let temperature: Double?
    let windSpeed: Double?
    let windDirection: Int?
    let chanceOfPrecipitation: Int?
    
    enum CodingKeys: String, CodingKey, Decodable {
        case id
        case name
        case longitude
        case latitude
        case temperature
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case chanceOfPrecipitation = "chance_of_precipitation"
    }
    
    var getName: String { name ?? "" }
    var getLongitude: Double { longitude ?? 0.0 }
    var getLatitude: Double { latitude ?? 0.0 }
    var getTemperature: Int? { temperature.map { Int($0) }}
    
    var getCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: getLatitude, longitude: getLongitude)
    }
    
    var windRotateDegrees: Double {
        windDirection.map { Double($0) } ?? 0.0
    }
}
