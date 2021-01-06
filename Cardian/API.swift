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
    struct getConfigResponse: Codable {
        let data: CardianConfiguration
        let success: Bool
    }
    public static func getConfig(_ apiKey: String, version: String, callback: @escaping (CardianConfiguration?) -> ()) -> Void {
        let headers: HTTPHeaders = [
          "Cardian-API-Key": apiKey,
          "Accept": "application/json",
        ]
        
        print("in config")
        
        //TODO fix this to not throw if bad obj
        AF.request("https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/config/\(version)", headers: headers).responseJSON { response in
            guard let data = response.data else {
                // TODO maybe throw an error here? or callback with error
                print("There is no release for the given version and api key");
                return
            }
        
            do {
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode(getConfigResponse.self, from: data)
                let configuration = decodedResult.data
                callback(configuration)
            } catch let error {
                var cachedConfig: CardianConfiguration? = nil
                var cachedUIConfig: ConnectUiConfiguration? = nil
                
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
                        cachedUIConfig = try decoder.decode(ConnectUiConfiguration.self, from: uiData)
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
                print("Request failed with error: \(error), try from cache")
                
                // TODO tjhink of a better option
                if cachedConfig != nil && cachedUIConfig != nil {
                    callback(cachedConfig)
                }
                
                print(error)
                callback(nil)
            }
        }
    }
    
    public static func uploadQuantityHealthData(_ apiKey: String, data: [CardianRecord]) {
        let url = "https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/records"
        print("Health data \(data)")
        
        let headers: HTTPHeaders = [
          "Cardian-API-Key": apiKey,
          "Accept": "application/json",
        ]
        
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            print("Upload Response\(response)")
        }
        
    }
}
