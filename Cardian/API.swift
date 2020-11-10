//
//  API.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/17/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    public static func getConfig(_ apiKey: String, callback: @escaping (CardianConfiguration, ConnectUIConfiguration) -> ()) -> Void {
        print("hello")
        let thing = AF.request("https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/config").responseJSON { response in switch response.result {
            case .success(let JSON):
                // TODO error checking
                let response = JSON as! NSDictionary

                //example if there is an id
                let dataObject = response.object(forKey: "data")!
                let data = dataObject as! NSDictionary
                print(data)
                let theme = data.object(forKey: "theme") as! NSDictionary
                let views = theme.object(forKey: "views") as! NSDictionary

                let introduction = views.object(forKey: "introduction") as! NSDictionary
                let usage = views.object(forKey: "usage") as! NSDictionary
                let completion = views.object(forKey: "completion") as! NSDictionary
                
                let newConfig = CardianConfiguration(
                    metrics: "",
                    appName: data.object(forKey: "app_name") as! String,
                    completion: "true",
                    themeIconUrl: theme.object(forKey: "icon_url") as! String,
                    themePrimaryColor: theme.object(forKey: "primary") as! String)
                
                
                let uiConfiguration = ConnectUIConfiguration(
                    cardianUrl: data.object(forKey: "cardian_url") as! String,
                    introductionHeader: introduction.object(forKey: "header") as! String,
                    introductionTitle1: introduction.object(forKey: "bullet_1_title") as! String,
                    introductionBody1: introduction.object(forKey: "bullet_1_body") as! String,
                    introductionTitle2: introduction.object(forKey: "bullet_2_title") as! String,
                    introductionBody2: introduction.object(forKey: "bullet_2_body") as! String,
                    introductionButtonLabel: introduction.object(forKey: "button_label") as! String,
                    usageTitle: usage.object(forKey: "title") as! String,
                    usageDescription: usage.object(forKey: "description") as! String,
                    usageButtonLabel: usage.object(forKey: "button_label") as! String,
                    completionTitle: completion.object(forKey: "title") as! String,
                    completionBody: completion.object(forKey: "body") as! String,
                    completionButtonLabel: completion.object(forKey: "button_label") as! String,
                    authMetrics: getSampleAuthMetrics(),
                    metricCollections: getSampleMetricCollections())
                
                
                
                print(newConfig)
                print(uiConfiguration)
                callback(newConfig, uiConfiguration)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    public static func getSampleAuthMetrics() -> AuthMetrics {
        let heightMetric = Metric(name: "height", displayName: "Height", type: "quantityMetric", description: "Your current recorded height")
        let weightMetric = Metric(name: "weight", displayName: "Weight", type: "quantityMetric", description: "Your current recorded body mass")
        let heartRateMetric = Metric(name: "heartRate", displayName: "Heart Rate", type: "quantity", description: "This is your heart rate.")
        let bodyTemperatureMetric = Metric(name: "bodyTemperature", displayName: "Body Temperature", type: "quantity", description: "This is your body temperature.")
        let authMetrics = AuthMetrics(read: [heightMetric, weightMetric, heartRateMetric, bodyTemperatureMetric], write: [heightMetric])
        return authMetrics
    }
    
    public static func getSampleMetricCollections() -> [MetricCollection] {
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
    
    
    
    public static func getSampleDisclosureDataSource() -> ConnectUIConfiguration {
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
