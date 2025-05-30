//
//  StationViewModel.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import Observation
import Combine
import MapKit

class StationViewModel: ObservableObject {
    @Published var visibleStations: [Station]
    @Published var errorMessage: String?
    @Published var loadingIndicator: MapProcessStatus
    @Published var downloadMapSuccess: Bool
    
    private var allStations: [Station]
    private var region: MKCoordinateRegion
    private var cancellables = Set<AnyCancellable>()
    
    private var networkMonitor: any NetworkMonitor
    private var onlineService: StationFetchingService
    private var offlineService: StationDataService
    
    init(onlineService: StationFetchingService, offlineService: StationDataService, networkMonitor: any NetworkMonitor) {
        self.allStations = []
        self.visibleStations = []
        self.onlineService = onlineService
        self.offlineService = offlineService
        self.networkMonitor = networkMonitor
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.9240, longitude: -108.0955),
                                         span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 20))
        self.errorMessage = nil
        self.downloadMapSuccess = false
        self.loadingIndicator = .none
    }
    
    func getRegion() -> MKCoordinateRegion { return self.region }
    func updateRegionAndLoadStations(region: MKCoordinateRegion) {
        self.region = region
        filterStations()
    }
    
    private func filterStations() {
        guard !allStations.isEmpty else { return }
        let minLat = region.center.latitude - (region.span.latitudeDelta / 2)
        let maxLat = region.center.latitude + (region.span.latitudeDelta / 2)
        let minLon = region.center.longitude - (region.span.longitudeDelta / 2)
        let maxLon = region.center.longitude + (region.span.longitudeDelta / 2)
        
        visibleStations = allStations.filter { station in
            guard let lat = station.latitude, let lon = station.longitude else { return false }
            
            return lat >= minLat && lat <= maxLat && lon >= minLon && lon <= maxLon
        }
        self.errorMessage = nil
        
        print("visibleStations count: \(visibleStations.count)")
    }
    
    private func fetchMap(with option: DateOption, service: StationFetchingService) {
        loadingIndicator = .processing
        service.getAllStations(with: option)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.message
                    self?.loadingIndicator = .finished
                }
            }, receiveValue: { [weak self] data in
                if data.isEmpty {
                    self?.errorMessage = RequestError.noData.message
                } else {
                    self?.allStations = data.filter { $0.longitude != nil && $0.latitude != nil }
                    self?.filterStations()
                }
                self?.loadingIndicator = .finished
            })
            .store(in: &cancellables)
    }
    
    func fetchAllStations(with option: DateOption) {
        if networkMonitor.isConnected {
            fetchMap(with: option, service: onlineService)
            print("Load online map")
        } else {
            fetchMap(with: option, service: offlineService)
            print("Load offline map")
        }
    }
    
    func downloadMap(dateOption: DateOption) {
        
        self.downloadMapSuccess = false
        self.loadingIndicator = .processing
        
        offlineService.saveMap(dateOption: dateOption, stations: allStations)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.errorMessage = error.message
                    self.loadingIndicator = .finished
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.downloadMapSuccess = result
                self.loadingIndicator = .finished
            })
            .store(in: &cancellables)
    }
}
