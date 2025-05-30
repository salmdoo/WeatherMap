//
//  StationCoreDataServiceImp.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import CoreData
import Combine


struct StationCoreDataServiceImp: StationDataService {
    
    private let fetchRequest: NSFetchRequest<WeatherDataModel>
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        fetchRequest = WeatherDataModel.fetchRequest()
        container = NSPersistentContainer(name: "WeatherData")
        loadPersistentStores()
    }
    
    func fetchAllMaps(dateOption: DateOption) throws -> [WeatherDataModel]  {
        fetchRequest.predicate = NSPredicate(format: "dateOption == %@", dateOption.rawValue)
        return try context.fetch(fetchRequest)
    }
    
    func deleteMap(dateOption: DateOption) throws {
        let fetchResult = try fetchAllMaps(dateOption: dateOption)
        fetchResult.forEach { context.delete($0) }
        try saveContext()
    }
    
    func saveMap(dateOption: DateOption,stations: [Station]) -> AnyPublisher<Bool, RequestError> {
        do {
            try deleteMap(dateOption: dateOption)
            
            let map = createWeatherDataModel(dateOption: dateOption)
            
            for station in stations {
                let stationDM = createStationDataModel(from: station)
                map.addToStations(stationDM)
            }
            
            try saveContext()
            
            return Just(true)
                .setFailureType(to: RequestError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: RequestError.others(error)).eraseToAnyPublisher()
        }
    }
    
    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError> {
        do {
            let mapData = try fetchAllMaps(dateOption: option)
            let stations: [Station] = mapData.compactMap { weather in
                (weather.stations as? Set<StationDataModel>)?.map { stationData in
                    convertToStation(stationData)
                }
            }.flatMap { $0 }
            
            return Just(stations)
                .setFailureType(to: RequestError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: RequestError.noData).eraseToAnyPublisher()
        }
        
    }
}

extension StationCoreDataServiceImp {
    private func loadPersistentStores() {
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Write error to log
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private func createWeatherDataModel(dateOption: DateOption) -> WeatherDataModel {
        let map = WeatherDataModel(context: context)
        map.dateOption = dateOption.rawValue
        return map
    }
    
    private func createStationDataModel(from station: Station) -> StationDataModel {
        let stationDM = StationDataModel(context: context)
        stationDM.id = station.id
        stationDM.name = station.name
        stationDM.longitude = station.longitude ?? 0.0
        stationDM.latitude = station.latitude ?? 0.0
        stationDM.temperature = station.temperature ?? 0.0
        stationDM.windSpeed = station.windSpeed ?? 0.0
        stationDM.windDirection = Int16(station.windDirection ?? 0)
        stationDM.chanceOfPrecipitation = Int16(station.chanceOfPrecipitation ?? 0)
        return stationDM
    }
    
    private func convertToStation(_ stationData: StationDataModel) -> Station {
        return Station(
            id: stationData.id ?? UUID().uuidString,
            name: stationData.name,
            longitude: stationData.longitude,
            latitude: stationData.latitude,
            temperature: stationData.temperature,
            windSpeed: stationData.windSpeed,
            windDirection: Int(stationData.windDirection),
            chanceOfPrecipitation: Int(stationData.chanceOfPrecipitation)
        )
    }
    
    private func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
