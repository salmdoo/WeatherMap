//
//  StationDetails.swift
//  WeatherOnMapApp
//
//  Created by Salmdoo on 3/30/25.
//

import SwiftUI

struct StationDetailsView: View {
    @Binding var selectedStation: Station?
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    var body: some View {
        if let station = selectedStation {
            VStack(spacing: 12) {
                headerView(for: station)
                Divider()
                stationInfoList(for: station)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .transition(.move(edge: .bottom))
        }
    }
}

// MARK: - Subviews
extension StationDetailsView {
    
    private func headerView(for station: Station) -> some View {
        HStack {
            Text(station.getName)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            closeButton
        }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            updateOrientation()
        }
    }
    
    private func updateOrientation() {
        isLandscape = UIDevice.current.orientation.isLandscape
    }
    
    private var closeButton: some View {
        Button(action: {
            selectedStation = nil
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
    
    private func stationInfoList(for station: Station) -> some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 50), count: isLandscape ? 2 : 1)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            stationInfo(icon: MapOption.temperature.imageName, title: "Temperature", value: station.getTemperature, unit: MapOption.temperature.measurementUnit)
            stationInfo(icon: MapOption.windSpeed.imageName, title: "Wind Speed", value: station.windSpeed, unit: MapOption.windSpeed.measurementUnit)
            stationInfo(icon: MapOption.windDirection.imageName, title: "Wind Direction", value: station.windDirection, unit: MapOption.windDirection.measurementUnit, iconRotateDegrees: station.windRotateDegrees)
            stationInfo(icon: MapOption.precipitationchance.imageName, title: "Chance of Rain", value: station.chanceOfPrecipitation, unit: MapOption.precipitationchance.measurementUnit)
        }
    }
    
    @ViewBuilder
    private func stationInfo<T: CustomStringConvertible>(icon: String, title: String, value: T?, unit: String = "", iconRotateDegrees: Double = 0.0) -> some View {
        if let value = value {
            HStack {
                Image(systemName: icon)
                    .rotationEffect(.degrees(iconRotateDegrees))
                    .frame(width: 24)
                
                Text("\(title):")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("\(value) \(unit)")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    let station =  Station(id: "1", name: "Bluestone Lane Theatre District Coffee Shop Scullery", longitude: 37.7866028588383, latitude: -122.4146104690889, temperature: 89, windSpeed: 12, windDirection: 43, chanceOfPrecipitation: 3)
    return StationDetailsView(selectedStation: .constant(station))
}
