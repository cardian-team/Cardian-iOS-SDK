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


public struct promptForPermissionsOptions {
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
    private var connectUiConfig: ConnectUIConfiguration?
    
    private var connectionClosure: ((ConnectUIConfiguration) -> Void)?
    
    public init() {
        self.config = nil
        self.connectUiConfig = nil
        self.fetchingConfig = false
        self.connectionClosure = nil
        self.externalId = nil
    }
    
    
    // MARK: Public Functions
    public func configure(_ api_key: String) {
        self.apiKey = api_key
        self.fetchingConfig = true
        // Checck for a cached one under this API KEY
        API.getConfig(api_key, callback: self.setConfigurations)
    }
    
    
    public func promptForPermissions(presentationController: UIViewController, options: promptForPermissionsOptions? = nil, completion: @escaping (Bool) -> Void) {
        if (!self.fetchingConfig && self.config != nil && self.connectUiConfig != nil) {
            Connect.connect(presentationController: presentationController, completion: completion)
        } else {
            print("Still fetching.. would present a spinner")
            // Add spinner pop up or option for this
            self.connectionClosure = {
                (ConnectUIConfiguration) -> Void in
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
        if let uiConfig = self.connectUiConfig {
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
    private func setConfigurations(config: CardianConfiguration, uiConfig: ConnectUIConfiguration) {
        self.config = config
        self.connectUiConfig = uiConfig;
        self.fetchingConfig = false;
        if let connectionClosure = self.connectionClosure {
            connectionClosure(self.connectUiConfig!)
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
        
//        var quanitityRecords: [GenericHealthKitRecord] = [GenericHealthKitRecord]()
        
        // TODO Force Unwrap
        for metric in self.getAuthMetrics()!.read {
            
            switch metric.name {
            case "stepCount":
                HealthKitManager.getQuanitityMetric(healthKitType: .stepCount, start: startDate, end: endDate)
                { data in
                    API.uploadQuantityHealthData(self.apiKey!, data: data!)
                }
            case "heartRate":
                HealthKitManager.getHeartRate(start: startDate, end: endDate)
                { data in
                    API.uploadQuantityHealthData(self.apiKey!, data: data!)
                }
                
            default:
                print("HIT DEFAULT IN SYNC")
            }
        }
        
        // TODO combine all into one request
        
        // TODO Force unwrap
    }
    
    func getConnectUIConfiguration() -> ConnectUIConfiguration? {
        return self.connectUiConfig
    }
    
    func getAuthMetrics() -> AuthMetrics? {
        if let config = self.config {
            return config.authMetrics
        }
        return nil
    }
    
    func setExternalId(_ externalId: String) {
        self.externalId = externalId
    }
}
