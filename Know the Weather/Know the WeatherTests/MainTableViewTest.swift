//
//  MainTableViewTest.swift
//  Know the WeatherTests
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import XCTest
@testable import Know_the_Weather

class MainTableViewTest: XCTestCase {
    private let mainTableViewModel = MainTableViewModel()
    private let apiCaller = OpenWeatherMapSurvice()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDayTimeFlagToReturnTrueWhenTheCurrentTimeIsBetweenSunriseAndSunset() {
        XCTAssertTrue(mainTableViewModel.dayTimeFlag(time: 1630919482, sunriseTime: 1630901732, sunsetTime: 1630943857))
    }
    

}
