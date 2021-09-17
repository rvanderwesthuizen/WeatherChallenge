//
//  MainTableViewTest.swift
//  Know the WeatherTests
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import XCTest
@testable import Know_the_Weather
import CoreLocation

class MainTableViewTest: XCTestCase {
    private let mainTableViewModel = MainTableViewModel()
    private let apiCaller = OpenWeatherMapService()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCurrentCityDoesReturnWhenTheCityExists() {
        mainTableViewModel.currentSelectedLocation = CLLocation(latitude: 37.33233141, longitude: -122.0312186)
        mainTableViewModel.currentCity { result in
            switch result {
            case .success(let city):
                XCTAssert(city == "Cupertino")
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testCurrentCityCausesErrorWhenTheCityDoesNotExist() {
        mainTableViewModel.currentSelectedLocation = CLLocation(latitude: 0, longitude: 0)
        mainTableViewModel.currentCity { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }
}
