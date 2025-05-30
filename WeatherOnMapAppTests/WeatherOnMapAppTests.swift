//
//  WeatherOnMapAppTests.swift
//  WeatherOnMapAppTests
//
//  Created by Salmdoo on 3/30/25.
//

import XCTest
import Combine
@testable import WeatherOnMapApp

class StationViewModelTests: XCTestCase {
    var viewModel: StationViewModel!
    var mockOfflineService: MockServiceImp!
    var mockOnlineService: MockServiceImp!
    var mockNetworkMonitorImp: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockOfflineService = MockServiceImp()
        mockOnlineService = MockServiceImp()
        mockNetworkMonitorImp = MockNetworkMonitor(isConnected: true)
        viewModel = StationViewModel(onlineService: mockOnlineService, offlineService: mockOfflineService, networkMonitor: mockNetworkMonitorImp)
    }

    override func tearDown() {
        viewModel = nil
        mockOfflineService = nil
        mockOnlineService = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func test_fetchOnlineMap_Success_WithData() {
        let station1 = Station(
            id: "1",
            name: "San Francisco Weather Station",
            longitude: -107.5,
                latitude: 41.2,
            temperature: 18.5,
            windSpeed: 5.2,
            windDirection: 90,
            chanceOfPrecipitation: 20
        )

        let station2 = Station(
            id: "2",
            name: "Los Angeles Weather Station",
            longitude: -108.2,
                latitude: 40.5,
            temperature: 22.0,
            windSpeed: 3.8,
            windDirection: 180,
            chanceOfPrecipitation: 10
        )
        let stations = [station1, station2]
        mockOnlineService.result = Just(stations)
            .setFailureType(to: RequestError.self)
            .eraseToAnyPublisher()

        viewModel.fetchAllStations(with: .today)

        XCTAssertEqual(viewModel.loadingIndicator, .finished)
        XCTAssertEqual(viewModel.visibleStations.count, stations.count)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_fetchOnlineMap_Success_NoData() {
        mockOnlineService.result = Just([])
            .setFailureType(to: RequestError.self)
            .eraseToAnyPublisher()

        viewModel.fetchAllStations(with: .today)

        XCTAssertEqual(viewModel.loadingIndicator, .finished)
        XCTAssertEqual(viewModel.visibleStations.count, 0)
        XCTAssertEqual(viewModel.errorMessage, RequestError.noData.message)
    }

    func test_fetchOnlineMap_Failure() {
        let expectedError = RequestError.badServerResponse
        mockOnlineService.result = Fail(error: expectedError)
            .eraseToAnyPublisher()

        viewModel.fetchAllStations(with: .today)

        XCTAssertEqual(viewModel.loadingIndicator, .finished)
        XCTAssertEqual(viewModel.errorMessage, expectedError.message)
        XCTAssertEqual(viewModel.visibleStations.count, 0)
    }
}



