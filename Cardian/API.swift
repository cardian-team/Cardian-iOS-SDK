//
//  API.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/17/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation

class API {
    func getConfig() {
    
    }
    
    func getSampleAuthMetrics() -> AuthMetrics {
        let heightMetric = Metric(name: "height", displayName: "Height", type: "quantityMetric", description: "Your current recorded height")
        let weightMetric = Metric(name: "weight", displayName: "Weight", type: "quantityMetric", description: "Your current recorded body mass")
        let heartRateMetric = Metric(name: "heartRate", displayName: "Heart Rate", type: "quantity", description: "This is your heart rate.")
        let bodyTemperatureMetric = Metric(name: "bodyTemperature", displayName: "Body Temperature", type: "quantity", description: "This is your body temperature.")
        let authMetrics = AuthMetrics(read: [heightMetric, weightMetric, heartRateMetric, bodyTemperatureMetric], write: [heightMetric])
        return authMetrics
    }
    
    func getSampleMetricCollections() -> [MetricCollection] {
        let heightMetric = Metric(name: "height", displayName: "Height", type: "quantity", description: "This is your height.")
        let weightMetric = Metric(name: "weight", displayName: "Weight", type: "quantity", description: "This is your weight.")
        let heartRateMetric = Metric(name: "heartrate", displayName: "Heart Rate", type: "quantity", description: "This is your heart rate.")
        let bodyTemperatureMetric = Metric(name: "bodytemp", displayName: "Body Temperature", type: "quantity", description: "This is your body temperature.")
        let sleepCountMetric = Metric(name: "sleepcount", displayName: "Sleep Count", type: "quantity", description: "This is your sleep count.")
        let stepCountMetric = Metric(name: "stepcount", displayName: "Step Count", type: "quantity", description: "This is your step count.")

        let metricCollection = MetricCollection(name: "Body Measurements", metrics: [heightMetric, weightMetric, heartRateMetric, bodyTemperatureMetric])
        let metricCollection2 = MetricCollection(name: "Advanced Measurements", metrics: [sleepCountMetric, stepCountMetric])
        return [metricCollection, metricCollection2]
    }
    
    
    
    func getSampleDisclosureDataSource() -> ConnectUIConfiguration {
        return ConnectUIConfiguration(cardianUrl: "",
                                      introductionHeader: "Trana uses Cardian to connect to Apple Health",
                                      introductionTitle1: "Transparency",
                                      introductionBody1: "Keeping you in the know about how your health data is being used by apps.",
                                      introductionTitle2: "Security",
                                      introductionBody2: "Your data is encrypted",
                                      introductionButtonLabel: "Continue",
                                      usageTitle: "How your data will be used",
                                      usageDescription: "Below is a breakdown of how Trana uses your data",
                                      usageButtonLabel: "Continue",
                                      completionTitle: "Success",
                                      completionBody: "Your health data was synced with Trana",
                                      completionButtonLabel: "Complete",
                                      authMetrics: getSampleAuthMetrics(),
                                      metricCollections: getSampleMetricCollections())
        
    }
}
