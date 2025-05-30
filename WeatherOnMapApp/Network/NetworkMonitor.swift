//
//  NetworkMonitor.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/30/25.
//

import Foundation
import Network

protocol NetworkMonitor: ObservableObject {
    var isConnected: Bool { get }
}

final class NetworkMonitorImp: NetworkMonitor {
    static let shared = NetworkMonitorImp()
    let networkMonitor: NWPathMonitor
    let workerQueue: DispatchQueue
    
    @Published private(set) var isConnected = false
    
    private init() {
        networkMonitor = NWPathMonitor()
        workerQueue = DispatchQueue(label: "NetworkMonitor")
        
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        
        networkMonitor.start(queue: workerQueue)
    }
}
