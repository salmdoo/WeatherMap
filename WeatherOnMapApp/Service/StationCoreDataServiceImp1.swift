//
//  StationCoreDataServiceImp.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import CoreData
import Combine


struct StationCoreDataServiceImp1: StationService {
    
    private let fetchRequest: NSFetchRequest<StationDataModel>
    let container: NSPersistentContainer
    
    init() {
        fetchRequest = StationDataModel.fetchRequest()
        container = NSPersistentContainer(name: "WeatherData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func fetchAllMaps() throws -> [StationDataModel]  {
        let context = container.viewContext
        return try context.fetch(fetchRequest)
    }
    
    func saveMap(map: StationDataModel) throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func deleteMap() throws {
        let context = container.viewContext
        
        let fetchResult = try context.fetch(fetchRequest)
        
        for item in fetchResult {
            context.delete(item)
        }
        
        if context.hasChanges {
            try context.save()
        }
        
    }
    
    func saveMap(stations: [Station]) -> AnyPublisher<Bool, RequestError> {
        do {
            try deleteMap()
            
            for station in stations {
                let map = StationDataModel(context: container.viewContext)
                map.id = station.id
                map.name = station.name
                map.longitude = station.longitude ?? 0.0
                map.latitude = station.latitude ?? 0.0
                map.temperature = station.temperature ?? 0.0
                map.windSpeed = station.windSpeed ?? 0.0
                map.windDirection = Int16(station.windDirection ?? 0)
                map.chanceOfPrecipitation = Int16(station.chanceOfPrecipitation ?? 0)
                try saveMap(map: map)
            }
            return Just(true)
                .setFailureType(to: RequestError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: RequestError.others(error)).eraseToAnyPublisher()
        }
    }
    
    func getAllStations(with option: DateOption) -> AnyPublisher<[Station], RequestError> {
        do {
            let mapData = try fetchAllMaps()
            let stations = mapData.map { station in
                    return Station(
                        id: station.id ?? UUID().uuidString,
                        name: station.name,
                        longitude: station.longitude,
                        latitude: station.latitude,
                        temperature: station.temperature,
                        windSpeed: station.windSpeed,
                        windDirection: Int(station.windDirection),
                        chanceOfPrecipitation: Int(station.chanceOfPrecipitation)
                    )
                }
            
            return Just(stations)
                .setFailureType(to: RequestError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: RequestError.noData).eraseToAnyPublisher()
        }
        
    }
}
