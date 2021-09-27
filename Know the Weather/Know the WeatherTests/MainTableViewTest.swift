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
    private var implementationUnderTest: MainTableViewModel!
    
    override func setUpWithError() throws {
        implementationUnderTest = MainTableViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCurrentCityDoesReturnWhenTheCityExists() {
        implementationUnderTest.currentSelectedLocation = CLLocation(latitude: 37.33233141, longitude: -122.0312186)
        implementationUnderTest.currentCity { result in
            switch result {
            case .success(let city):
                XCTAssert(city == "Cupertino")
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testCurrentCityCausesErrorWhenTheCityDoesNotExist() {
        implementationUnderTest.currentSelectedLocation = CLLocation(latitude: 0, longitude: 0)
        implementationUnderTest.currentCity { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }
    
    func testForFailureWhenIndexOutOfBounds() {
        if let _ = implementationUnderTest.dailyWeather(at: -1),
           let _ = implementationUnderTest.dailyWeatherSunrise(at: -1) {
            XCTFail()
        }
    }
    
    func testFetchLastKnownLocation() {
        implementationUnderTest.fetchLastKnownLocation { result in
            switch result{
            case .success(let location):
                XCTAssertNotNil(location)
            case .failure(_):
                XCTFail()
            }
        }
    }
}
