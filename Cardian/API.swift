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
    
    struct uploadQueryResponse: Codable {
        struct nestedData: Codable {
            let records: [QuantitativeCardianRecord]
        }
        let data: nestedData
        let success: Bool
    }
    
    public static func getConfig(_ apiKey: String, version: String, callback: @escaping (ConfigureResult<CardianConfiguration, Error>) -> Void) -> Void {
        let headers: HTTPHeaders = [
          "Cardian-API-Key": apiKey,
          "Accept": "application/json",
        ]
        
        print("in config")
        
        AF.request("https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/config/\(version)", headers: headers).responseJSON { response in
            guard let data = response.data else {
                callback(.failure(CardianError.configurationNotFound))
                return
            }
        
            do {
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode(getConfigResponse.self, from: data)
                let configuration = decodedResult.data
                callback(.success(configuration))
            } catch let error {
                var cachedConfig: CardianConfiguration? = nil
                var cachedUIConfig: ConnectUiConfiguration? = nil
                
                if let appData = UserDefaults.standard.data(forKey: "CARDIAN_INTERNAL_APP_CONFIG_\(apiKey)_\(version)") {
                    do {
                        // Create JSON Decoder
                        let decoder = JSONDecoder()
        
                        // Decode Note
                        cachedConfig = try decoder.decode(CardianConfiguration.self, from: appData)
        
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
                if let uiData = UserDefaults.standard.data(forKey: "CARDIAN_INTERNAL_CONNECT_UI_CONFIG_\(apiKey)_\(version)") {
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
                
                if cachedConfig != nil && cachedUIConfig != nil {
                    callback(.cached(cachedConfig!))
                    callback(.success(cachedConfig!))
                }
                
                print(error)
                callback(.failure(CardianError.configurationNotFound))
            }
        }
    }
    
    public static func uploadQuantityHealthData(_ apiKey: String, externalId: String, data: [CardianRecord]) {
        let url = "https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/records"
        print("Health data \(data)")
        
        let headers: HTTPHeaders = [
            "Cardian-API-Key": apiKey,
            "Cardian-User-Id": externalId,
            "Accept": "application/json",
        ]
        
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            print("Upload Response\(response)")
        }
    }
    
    
    public static func uploadQuery(_ apiKey: String, externalId: String, query: CodableQuery, completion: ((Result<[QuantitativeCardianRecord], Error>) -> Void)?) {
        let url = "https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/query"
        
        let headers: HTTPHeaders = [
            "Cardian-API-Key": apiKey,
            "Cardian-User-Id": externalId,
            "Accept": "application/json",
        ]
        
        AF.request(url, method: .post, parameters: query, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            guard let data = response.data else {
                if let completion = completion {
                    print("In compeltions no completionsunknownQueryError")
                    completion(.failure(CardianError.unknownQueryError))
                }
                return
            }
            do {
                print("QUERY Response \(response)")
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode(uploadQueryResponse.self, from: data)
                if let completion = completion {
                    completion(.success(decodedResult.data.records))
                }
            } catch {
                print("Catch \(error)")
                if let completion = completion {
                    completion(.failure(CardianError.unknownQueryError))
                }
            }
        }
    }
    
    public static func uploadEvent(_ apiKey: String, externalId: String, events: [CardianEvent]) {
        let url = "https://tnggeogff3.execute-api.us-east-1.amazonaws.com/dev/analytics"
        let headers: HTTPHeaders = [
            "Cardian-API-Key": apiKey,
            "Cardian-User-Id": externalId,
            "Accept": "application/json",
        ]
        
        AF.request(url, method: .post, parameters: events, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            guard let data = response.data else {
                print("TODO FIX ERROR HERE \(response)")
                return
            }
                print("TODO EVENT Response\(data)")
        }
    }
}
