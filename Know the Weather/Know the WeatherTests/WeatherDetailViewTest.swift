//
//  WeatherDetailViewTest.swift
//  Know the WeatherTests
//
//  Created by Ruan van der Westhuizen on 2021/09/27.
//

import XCTest
@testable import Know_the_Weather
import CoreLocation

class WeatherDetailViewTest: XCTestCase {
    private var implementationUnderTest: WeatherDetailViewModel!
    
    override func setUpWithError() throws {
        implementationUnderTest = WeatherDetailViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
