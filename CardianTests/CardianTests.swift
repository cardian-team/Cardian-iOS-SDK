//
//  CardianTests.swift
//  CardianTests
//
//  Created by Mitchell Sweet on 9/3/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import XCTest
@testable import Cardian

class CardianTests: XCTestCase {

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
    
    func testAuthorization() {
        let heightMetric = Metric(name: "height", displayName: "Height", type: "quantityMetric", description: "Your current recorded height")
        let weightMetric = Metric(name: "weight", displayName: "Weight", type: "quantityMetric", description: "Your current recorded body mass")
        let authMetrics = AuthMetrics(read: [heightMetric, weightMetric], write: [heightMetric])
        AuthManager.authorize(authMetrics: authMetrics) { (success, error) in
            XCTAssertTrue(success)
        }
    }
    
    func testGetWeight() {
        HealthKitManager.getCurrentWeight { (weight) in
            print("WEIGHT: \(weight ?? -1.0)")
            XCTAssertNotNil(weight)
        }
    }
    
    func testGetHeight() {
        HealthKitManager.getCurrentHeight { (height) in
            print("WEIGHT: \(height ?? -1.0)")
            XCTAssertNotNil(height)
        }
    }
    
    func testBreakdownView() {
        
        let heightMetric = Metric(name: "height", displayName: "Height", type: "quantity", description: "This is your height.")
        let weightMetric = Metric(name: "weight", displayName: "Weight", type: "quantity", description: "This is your weignt.")
        let heartRateMetric = Metric(name: "heartrate", displayName: "Heart Rate", type: "quantity", description: "This is your heart rate.")
        let bodyTemperatureMetric = Metric(name: "bodytemp", displayName: "Body Temperature", type: "quantity", description: "This is your body temperature.")
        let sleepCountMetric = Metric(name: "sleepcount", displayName: "Sleep Count", type: "quantity", description: "This is your sleep count.")
        let stepCountMetric = Metric(name: "stepcount", displayName: "Step Count", type: "quantity", description: "This is your step count.")

        let metricCollection = MetricCollection(name: "Body Measurements", metrics: [heightMetric, weightMetric, heartRateMetric, bodyTemperatureMetric])
        let metricCollection2 = MetricCollection(name: "Advanced Measurements", metrics: [sleepCountMetric, stepCountMetric])

        let breakdownDataSource = BreakdownDataSource(title: "Understand How Your Data is Used", description: "Below is a breakdown of the data being gathered by this app and a description of how it is used.", actionTitle: "Continue", MetricCollections: [metricCollection, metricCollection2])

        let breakdownViewController = DataBreakdownController(dataSource: breakdownDataSource)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
