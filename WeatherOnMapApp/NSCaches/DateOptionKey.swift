//
//  DateOptionKey.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 4/17/25.
//

import Foundation

class DateOptionKey: NSObject, NSCopying { //The NSCache has a custom key, so it has to confirm NSCopying
    let option: DateOption
    
    init(option: DateOption) {
        self.option = option
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return DateOptionKey(option: option)
    }
    
    override var hash: Int {
        return option.rawValue.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DateOptionKey else {
            return false
        }
        return option.rawValue == other.option.rawValue
    }
}
