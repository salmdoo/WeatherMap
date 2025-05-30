//
//  WeatherNSCache.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 4/17/25.
//
import Foundation

class WeatherNSCache {
    private let cache = NSCache<DateOptionKey, NSArray>()
    
    init() {
        // Config NSCache with Auto Eviction
        cache.countLimit = 100 // Max number of items
        cache.totalCostLimit = 5 * 1024 * 1024 // Max 5 MB of memory
    }
    
    private func keyOfDate(date: DateOption) -> DateOptionKey {
        .init(option: date)
    }
    
    func store(date: DateOption, stations: [Station]) {
        cache.setObject(stations as NSArray, forKey: keyOfDate(date: date), cost: 0)
    }
    
    func load(date: DateOption) -> [Station]? {
        return cache.object(forKey: keyOfDate(date: date)) as? [Station]
    }
    
    func clear(date: DateOption) {
        cache.removeObject(forKey: keyOfDate(date: date))
    }
    
}
