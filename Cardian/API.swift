//
//  API.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/17/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import HealthKit
import Alamofire

class API {
    
    public static func getConfig(_ apiKey: String, callback: @escaping (CardianConfiguration, ConnectUIConfiguration) -> ()) -> Void {
        let headers: HTTPHeaders = [
          "X-API-Key": apiKey,
          "Accept": "application/json",
        ]
        
        //TODO fix this to not throw if bad obj
        AF.request("https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/config/4", headers: headers).responseJSON { result in switch result.result {
            case .success(let JSON):
                // TODO error checking
                let response = JSON as! NSDictionary
                
                //example if there is an id
                // TODO see if i can just use encodable??? thatd be sicko
                let dataObject = response.object(forKey: "data")!
                let data = dataObject as! NSDictionary
    
                let metrics = data.object(forKey: "metrics") as! NSDictionary
                let theme = data.object(forKey: "theme") as! NSDictionary
                let views = theme.object(forKey: "views") as! NSDictionary

                let introduction = views.object(forKey: "introduction") as! NSDictionary
                let usage = views.object(forKey: "usage") as! NSDictionary
                let completion = views.object(forKey: "completion") as! NSDictionary
                
                var readMetrics: [Metric] = []
                var writeMetrics: [Metric] = []
                for (key, value) in metrics {
                    let currentMetric = value as! NSDictionary
                    let newMetric = Metric(
                        name: key as! String,
                        displayName: currentMetric.object(forKey: "label") as! String,
                        type: currentMetric.object(forKey: "type") as! String,
                        description: "Deleting descriptions soon")
                    
                    let permissions = currentMetric.object(forKey: "mode") as! Int
                    
                    if (permissions > 0) {
                        readMetrics.append(newMetric)
                    }
                    
                    if (permissions == 2) {
                        writeMetrics.append(newMetric)
                    }
                }
                let readMetricsCollection = MetricCollection(name: "Readable Metrics", metrics: readMetrics)
                let writeMetricColleciton = MetricCollection(name: "Writeable", metrics: writeMetrics)
                let authMetrics = AuthMetrics(read: readMetrics, write: writeMetrics)
                
                let newConfig = CardianConfiguration(
                    version: "3",
                    appName: data.object(forKey: "app_name") as! String,
                    completion: "true",
                    themeIconUrl: theme.object(forKey: "icon_url") as! String,
                    themePrimaryColor: theme.object(forKey: "primary") as! String,
                    interval: "week",
                    authMetrics: authMetrics
                )
                
                
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
                    authMetrics: authMetrics,
                    metricCollections: [readMetricsCollection, writeMetricColleciton])
                
                callback(newConfig, uiConfiguration)
            case .failure(let error):
                var cachedConfig: CardianConfiguration? = nil
                var cachedUIConfig: ConnectUIConfiguration? = nil
                
                if let appData = UserDefaults.standard.data(forKey: "CARDIAN_INTERNAL_APP_CONFIG") {
                    do {
                        // Create JSON Decoder
                        let decoder = JSONDecoder()
        
                        // Decode Note
                        cachedConfig = try decoder.decode(CardianConfiguration.self, from: appData)
        
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
                if let uiData = UserDefaults.standard.data(forKey: "CARDIAN_INTERNAL_CONNECT_UI_CONFIG") {
                    do {
                        // Create JSON Decoder
                        let decoder = JSONDecoder()
        
                        // Decode Note
                        cachedUIConfig = try decoder.decode(ConnectUIConfiguration.self, from: uiData)
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
                print("Request failed with error: \(error), try from cache")
                
                // TODO tjhink of a better option
                if cachedConfig != nil && cachedUIConfig != nil {
                    callback(cachedConfig!, cachedUIConfig!)
                }
            }
        }
    }
    
    public static func uploadQuantityHealthData(_ apiKey: String, data: [GenericHealthKitRecord]) {
        let url = "https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/records"
        print("Health data \(data)")
        
        let headers: HTTPHeaders = [
          "X-API-Key": apiKey,
          "Accept": "application/json",
        ]
        
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            print("Upload Response\(response)")
        }
        
    }
}
