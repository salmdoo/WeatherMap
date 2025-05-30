//
//  WeatherOnMapApp.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import SwiftUI

@main
struct WeatherOnMapApp: App {
    @StateObject var stationVM = StationViewModel(
        onlineService: StationHTTPServiceImp(serviceRequest: HTTPServiceRequestImp()),
        offlineService: StationNSCacheServiceImp(),
        networkMonitor: NetworkMonitorImp.shared)

    var body: some Scene {
        WindowGroup {
            StationMapView(stationVM: stationVM)
        }
    }
}
