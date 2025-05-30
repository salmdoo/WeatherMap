//
//  MockNetworkMonitor.swift
//  WeatherOnMapApp
//
//  Created by Salmdo on 4/5/25.
//

import Foundation
import Combine
@testable import WeatherOnMapApp

class MockNetworkMonitor: NetworkMonitor {
    @Published var isConnected: Bool
    
    init(isConnected: Bool = true) {
        self.isConnected = isConnected
    }
}
