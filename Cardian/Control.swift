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


public struct PromptForPermissionsOptions {
    let presetationMode: String? = nil
}

// MARK: Class
public class Control {
    // Expose an instance of control
    public static let `default` = Control();
    
    let queue = DispatchQueue(label: "com.curaegis.cardian")
    // MARK: Instance Vars
    private var fetchingConfig: Bool
    private var apiKey: String?
    private var externalId: String?
    private var config: CardianConfiguration?
    
    private var connectionClosure: ((ConnectUiConfiguration) -> Void)?
    
    public init() {
        self.config = nil
        self.fetchingConfig = false
        self.connectionClosure = nil
        self.externalId = nil
    }
    
    
    // MARK: Public Functions
    public func configure(_ api_key: String, version: String = "^") {
        self.apiKey = api_key
        self.fetchingConfig = true
        // Checck for a cached one under this API KEY
        API.getConfig(api_key, version: version, callback: self.setConfigurations)
    }
    
    public func promptForPermissions(presentationController: UIViewController, options: PromptForPermissionsOptions? = nil, completion: @escaping (Bool) -> Void) {
        if (!self.fetchingConfig && self.config != nil && self.config?.connectUi != nil) {
            Connect.connect(presentationController: presentationController, completion: completion)
        } else {
            print("Still fetching.. would present a spinner")
            // Add spinner pop up or option for this
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
                UserDefaults.standard.set(data, forKey: "CARDIAN_INTERNAL_APP_CONFIG")
            } catch {
                print("Unable to Encode Cardian app config (\(error))")
            }
        }
        
        // store Connect UI Config in UserDefaults
        if let uiConfig = self.config?.connectUi {
            do {
                let data = try encoder.encode(uiConfig)
                UserDefaults.standard.set(data, forKey: "CARDIAN_INTERNAL_CONNECT_UI_CONFIG")
            } catch {
                print("Unable to Encode uiConfig (\(error))")
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
                versions = ConnectedVersions(versionsMap: [String: Bool](), latestConnectedVersion: self.config!.version)
                print("Unable to Decode Versions dict (\(error))")
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
    private func setConfigurations(config: CardianConfiguration?) {
        self.config = config
        self.fetchingConfig = false;
        if let connectionClosure = self.connectionClosure {
            connectionClosure(config!.connectUi)
        }
        
        self.cacheConfigsInDefaults()
    }
    
    private func getIntervalStartDate() -> Date {
        let weekInSeconds: Double = -7*24*60*60
        let now = Date()
        //TODO safe unwrap
        switch self.config!.interval {
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
    
    public func sync() {
        let endDate = Date()
        let startDate = self.getIntervalStartDate()
                
        // TODO Force Unwrap
        for metric in config!.metrics {
            // tODO read vs write here and clean handling
            print("in sync loop \(metric.label)")
            HealthKitManager.getHealthKitRecords(metric: metric, start: startDate, end: endDate) {
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
                    API.uploadQuantityHealthData(self.apiKey!, externalId: self.externalId!, data: data!)
                }
            }
        }
        
        // TODO combine all into one request
    }
    
    // TODO add callback with data..
    public func executeQuery(query: CardianQuery) {
        API.uploadQuery(self.apiKey!, externalId: self.externalId!, query: query.getCodableQuery())
    }
    
    func getConfiguration() -> CardianConfiguration? {
        return self.config
    }
    
    func getAuthMetrics() -> AuthMetrics {
        var readMetrics: [Metric] = []
        var writeMetrics: [Metric] = []
        // tODO force unwrap
        for (currentMetric) in self.config!.metrics {
            if (currentMetric.mode > 0) {
                readMetrics.append(currentMetric)
            }
            
            if (currentMetric.mode == 2) {
                writeMetrics.append(currentMetric)
            }
        }
        let authMetrics = AuthMetrics(read: readMetrics, write: writeMetrics)
        return authMetrics
    }
    
    public func setExternalId(_ externalId: String) {
        self.externalId = externalId
    }
}
