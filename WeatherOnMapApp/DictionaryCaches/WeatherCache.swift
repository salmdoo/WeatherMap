//
//  WeatherCache.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 4/16/25.
//

import Foundation

class WeatherCache {
    private var storage: [DateOption: [Station]] = [:]
    private var queue: DispatchQueue = .init(label: "com.salmdo.weatheronmapapp.weathercache")
    
    func store(for dateOption: DateOption, _ stations: [Station]) {
        queue.async {
            if self.storage[dateOption] == nil {
                self.storage[dateOption] = []
            }
            self.storage[dateOption]?.removeAll()
            self.storage[dateOption]?.append(contentsOf: stations)
        }
    }
    
    func load(for dateOption: DateOption) -> [Station]? {
        queue.sync {
            self.storage[dateOption]
        }
    }
    
    func clear() {
        queue.async {
            self.storage.removeAll()
        }
    }
    
    func clear(for dateOption: DateOption) {
        queue.async {
            self.storage[dateOption]?.removeAll()
        }
    }
    
    func isCached(for dateOption: DateOption) -> Bool {
        queue.sync {
            ((self.storage[dateOption]?.isEmpty) == nil)
        }
    }
}
