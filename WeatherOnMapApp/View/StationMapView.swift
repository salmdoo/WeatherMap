//
//  StationMapView.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/29/25.
//

import SwiftUI
import MapKit

struct StationMapView: View {
    @State private var selectedDateOption: DateOption = .today
    @State private var selectedMapOption: MapOption = .temperature
    @State private var selectedStation: Station?
    @State private var coordinateRegion: MKCoordinateRegion
    @State private var lastRegion: MKCoordinateRegion
    
    @ObservedObject var stationVM: StationViewModel
    
    init(stationVM: StationViewModel) {
        self.stationVM = stationVM
        let initialRegion = stationVM.getRegion()
        _coordinateRegion = State(initialValue: initialRegion)
        _lastRegion = State(initialValue: initialRegion)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if let errorMessage = stationVM.errorMessage {
                errorView(errorMessage: errorMessage)
            } else if stationVM.loadingIndicator == .processing {
                loadingView
            } else {
                mapView
            }
        }
        .alert("Download Successful", isPresented: $stationVM.downloadMapSuccess) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            stationVM.fetchAllStations(with: selectedDateOption)
        }
        .onChange(of: selectedDateOption) { _ in
            stationVM.fetchAllStations(with: selectedDateOption)
        }
    }
}

// MARK: - Subviews
extension StationMapView {
    private func errorView(errorMessage: String) -> some View {
        VStack(spacing: 5) {
            mapControls
                .padding(.bottom, 50)
            Text(errorMessage)
            Spacer()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 5) {
            Text("Map is loading")
            Image(systemName: "goforward")
        }
    }
    
    private var mapView: some View {
        Map(coordinateRegion: $coordinateRegion, annotationItems: stationVM.visibleStations) { station in
            mapAnnotation(for: station)
        }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            handleRegionChange()
        }
        .overlay(mapControls, alignment: .topLeading)
    }
    
    private func mapAnnotation(for station: Station) -> MapAnnotation<some View> {
        MapAnnotation(coordinate: station.getCoordinate) {
            HStack {
                Image(systemName: selectedMapOption.imageName)
                    .rotationEffect(.degrees(selectedMapOption.imageRotateDegrees(station: station)))
                    .scaleEffect(selectedStation == station ? 2.0 : 1.0)
                if let stationValue = selectedMapOption.value(station: station) {
                    Text(stationValue)
                }
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    selectedStation = station
                }
            }
        }
    }
    
    private var mapControls: some View {
        VStack(alignment: .trailing) {
            segmentedPicker(label: "Map Date", selection: $selectedDateOption, options: DateOption.allCases)
            segmentedPicker(label: "Map Option", selection: $selectedMapOption, options: MapOption.allCases.filter { $0 != .windSpeed })
            refreshButton(imageName: "square.and.arrow.down") {
                stationVM.downloadMap(dateOption: selectedDateOption)
            }
            if selectedStation != nil {
                Spacer()
                StationDetailsView(selectedStation: $selectedStation)
                    .frame(maxWidth: .infinity, minHeight: 250)
                    .zIndex(1)
            }
        }
        .padding()
    }
    
    func refreshButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(.primary)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
        }
        .frame(minWidth: 44, minHeight: 44)
    }
    
    func segmentedPicker<T: RawRepresentable & Hashable & Identifiable>(
        label: String,
        selection: Binding<T>,
        options: [T]
    ) -> some View where T.RawValue == String {
        Picker(label, selection: selection) {
            ForEach(options) { option in
                Text(option.rawValue.capitalized).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private func handleRegionChange() {
        if coordinateRegion.center.latitude != lastRegion.center.latitude ||
            coordinateRegion.center.longitude != lastRegion.center.longitude {
            lastRegion = coordinateRegion
            stationVM.updateRegionAndLoadStations(region: coordinateRegion)
        }
    }
}


#Preview {
    let offlineService: StationDataService = StationCoreDataServiceImp()
    let httpService: StationFetchingService = StationHTTPServiceImp(serviceRequest: HTTPServiceRequestImp())
    
    return StationMapView(stationVM: StationViewModel(onlineService: httpService, offlineService: offlineService, networkMonitor: NetworkMonitorImp.shared))
}
