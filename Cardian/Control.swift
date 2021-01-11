//
//  Control.swift
//  Cardian
//
//  Created by Owen Sullivan on 11/4/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

// MARK: Imports
import Foundation
import Alamofire
import UIKit

public enum ConfigureResult<Success, Failure: Error> {
    case success(Success)
    case cached(Success)
    case failure(Failure)
}

public struct PromptForPermissionsOptions {
    let presetationMode: String? = nil
}

// MARK: Class
public class Control {
    // Expose an instance of control
    public static let `default` = Control();
    
    // MARK: Instance Vars
    private var fetchingConfig: Bool
    private var apiKey: String = ""
    private var externalId: String = ""
    private var externalToken: String = ""
    private var config: CardianConfiguration?
    
    private var connectionClosure: ((ConnectUiConfiguration) -> Void)?
    
    public init() {
        self.config = nil
        self.fetchingConfig = false
        self.connectionClosure = nil
        self.externalId = ""
    }
    
    
    // MARK: Public Functions
    // DONE Add a callback
    public func configure(_ api_key: String, version: String = "^", completion: ((ConfigureResult<CardianConfiguration, Error>) -> Void)? = nil) {
        self.apiKey = api_key
        self.fetchingConfig = true

        API.getConfig(api_key, version: version) {
            result in
            switch (result) {
            case .success(let data):
                print(data)
                self.setConfigurations(data)
                if let completion = completion{
                    completion(result)
                }
            default:
                if let completion = completion{
                    completion(result)
                }
            }
        }
    }
    
    // TODO make the options actually do something and add a better callback with events
    public func promptForPermissions(presentationController: UIViewController, options: PromptForPermissionsOptions? = nil, completion: @escaping (Bool) -> Void) {
        if (!self.fetchingConfig && self.config != nil && self.config?.connectUi != nil) {
            Connect.connect(presentationController: presentationController, completion: completion)
        } else {
            print("Still fetching.. would present a spinner")
            // TODO Add spinner pop up or option for this
            self.connectionClosure = {
                (ConnectUiConfiguration) -> Void in
                Connect.connect(presentationController: presentationController, completion: completion)
            }
        }
    }
    
    // MARK: Private Functions
        private func cacheConfigsInDefaults() {
        let encoder = JSONEncoder()

        // store config in UserDefaults
        if let config = self.config {
            do {
                let data = try encoder.encode(config)
                UserDefaults.standard.set(data, forKey: "CARDIAN_INTERNAL_APP_CONFIG_\(self.apiKey)_\(config.version)")
            } catch {
                print("Unable to Encode Cardian app config (\(error))")
            }
            
            // store Connect UI Config in UserDefaults
            if let uiConfig = self.config?.connectUi {
                do {
                    let data = try encoder.encode(uiConfig)
                    UserDefaults.standard.set(data, forKey: "CARDIAN_INTERNAL_CONNECT_UI_CONFIG_\(self.apiKey)_\(config.version)")
                } catch {
                    print("Unable to Encode uiConfig (\(error))")
                }
            }
        }
    }
    
    
    public func updateVersionsConnected() {
        var versions: ConnectedVersions? = nil
        if let versionData = UserDefaults.standard.data(forKey: "CARDIAN_INTERNAL_CONNECTED_VERSIONS") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                versions = try decoder.decode(ConnectedVersions.self, from: versionData)
            } catch {
                // First time connecting health kit.
                versions = ConnectedVersions(versionsMap: [String: Bool](), latestConnectedVersion: self.config!.version)
            }
        }
        
        let encoder = JSONEncoder()
        if let config = self.config {
            versions?.latestConnectedVersion = config.version
            versions?.versionsMap[config.version] = true
            do {
                let data = try encoder.encode(versions)
                UserDefaults.standard.set(data, forKey: "CARDIAN_INTERNAL_CONNECTED_VERSIONS")
            } catch {
                print("Unable to Encode Connected Components (\(error))")
            }
        }
    }
    
    // MARK: Get/Setters
    private func setConfigurations(_ config: CardianConfiguration?) {
        self.config = config
        self.fetchingConfig = false;
        if let connectionClosure = self.connectionClosure {
            connectionClosure(config!.connectUi)
        }
        
        self.cacheConfigsInDefaults()
    }
    
    private func getIntervalStartDate() -> Date? {
        let weekInSeconds: Double = -7*24*60*60
        let now = Date()
        
        if let config = self.config {
            switch config.interval {
            case "day":
                return Calendar.current.startOfDay(for: now)
            case "week":
                let lastWeekDate = Date(timeIntervalSinceNow: weekInSeconds)
                return Calendar.current.startOfDay(for: lastWeekDate)
            default:
                let lastWeekDate = Date(timeIntervalSinceNow: weekInSeconds)
                return Calendar.current.startOfDay(for: lastWeekDate)
            }
        }
        return nil
    }
    
    // TODO add callbacks and options
    public func sync() {
        if let config = self.config {
            let endDate = Date()
            let startDate = self.getIntervalStartDate()
                    
            for metric in config.metrics {
                if (metric.mode == 1 || metric.mode == 2) {
                    print("in sync loop \(metric.label)")
                    HealthKitManager.getHealthKitRecords(metric: metric, start: startDate!, end: endDate) {
                        (data, schema) in
                        if (data == nil){
                            return
                        }
                        if (data!.isEmpty) {
                            print("was empty")
                            return
                        }
                        if (schema == MetricSchemaType.quantitative) {
                            print("in quant \(metric.label)")
                            API.uploadQuantityHealthData(self.apiKey, externalId: self.externalId, data: data!)
                        }
                    }
                }
            }
        }
    }
    
    // TODO add callback with data..
    public func executeQuery(query: CardianQuery) {
        API.uploadQuery(self.apiKey, externalId: self.externalId, query: query.getCodableQuery())
    }
    
    func getConfiguration() -> CardianConfiguration? {
        return self.config
    }
    
    func getAuthMetrics() -> AuthMetrics {
        var readMetrics: [Metric] = []
        var writeMetrics: [Metric] = []
        
        if let config = self.config {
            for (currentMetric) in config.metrics {
                if (currentMetric.mode  == 1 || currentMetric.mode == 2) {
                    readMetrics.append(currentMetric)
                }
                
                if (currentMetric.mode == 2 || currentMetric.mode == 3) {
                    writeMetrics.append(currentMetric)
                }
            }
        }
        let authMetrics = AuthMetrics(read: readMetrics, write: writeMetrics)
        return authMetrics
    }
    
    public func setExternalId(_ externalId: String) {
        self.externalId = externalId
    }
    
    public func setExternalToken(_ externalToken: String) {
        self.externalToken = externalToken
    }
}
