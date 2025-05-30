//
//  WeatherMapEnums.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/30/25.
//

enum DateOption: String, Identifiable, CaseIterable {
    case today
    case tomorrow
    
    var id: String {
        self.rawValue
    }
}

enum MapProcessStatus {
    case processing
    case finished
    case none
}

enum MapOption: String, Identifiable, CaseIterable {
    case temperature = "Temperature"
    case windSpeed = "Wind Speed"
    case precipitationchance = "Precipitation"
    case windDirection = "Wind"
    
    var id: String {
        self.rawValue
    }
    
    var imageName: String {
        switch self {
        case .temperature:
            return "thermometer"
        case .windSpeed:
            return "wind"
        case .windDirection:
            return "arrow.up"
        case .precipitationchance:
            return "cloud.rain"
        }
    }
    
    var measurementUnit: String {
        switch self {
        case .temperature:
            return "°F"
        case .windSpeed:
            return "km/h"
        case .windDirection:
            return "°"
        case .precipitationchance:
            return "%"
        }
    }
    
    func imageRotateDegrees(station: Station) -> Double {
        switch self {
        case .windDirection:
            return station.windRotateDegrees
        default:
            return 0.0
        }
    }
    
    func value(station: Station) -> String? {
        switch self {
        case .temperature:
            return station.getTemperature.map { "\($0) \(measurementUnit)" }
        case .windSpeed:
            return station.windSpeed.map { "\($0) \(measurementUnit)" }
        case .windDirection:
            return station.windSpeed.map { "\($0) km/h" }
        case .precipitationchance:
            return station.chanceOfPrecipitation.map { "\($0) \(measurementUnit)" }
        }
    }
}
