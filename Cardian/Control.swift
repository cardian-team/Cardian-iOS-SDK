//
//  Control.swift
//  Cardian
//
//  Created by Owen Sullivan on 11/4/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public class Control {
    // Expose an instance of control
    public static let `default` = Control();
    
    let queue = DispatchQueue(label: "com.curaegis.cardian")
    // Privates
    private var fetchingConfig: Bool
    private var apiKey: String?
    private var config: CardianConfiguration?
    private var connectUiConfig: ConnectUIConfiguration?
    private var authMetrics: AuthMetrics?
    
    private var connectionClosure: ((ConnectUIConfiguration) -> Void)?
    
    public init() {
        self.config = nil
        self.connectUiConfig = nil
        self.fetchingConfig = false
        self.connectionClosure = nil
        self.authMetrics = nil
    }
    

    public func configure(_ api_key: String) {
        self.apiKey = api_key
        self.fetchingConfig = true
        // Checck for a cached one under this API KEY
        API.getConfig(api_key, callback: self.setConfigurations)
    }
    
    private func setConfigurations(config: CardianConfiguration, uiConfig: ConnectUIConfiguration, authMetrics: AuthMetrics) {
        self.config = config
        self.connectUiConfig = uiConfig;
        self.authMetrics = authMetrics
        self.fetchingConfig = false;
        if let connectionClosure = self.connectionClosure {
            connectionClosure(self.connectUiConfig!)
        }
    }
    
    public func connect(presentationController: UIViewController, completion: @escaping (Bool) -> Void) {
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
        for metric in self.authMetrics!.read {
            
            switch metric.name {
            case "stepCount":
                HealthKitManager.getQuanitityMetric(healthKitType: .stepCount, start: startDate, end: endDate)
                    { data in
                        
                    API.uploadQuantityHealthData(self.apiKey!, data: data!)
                }
                
            default:
                print("HIT DEFAULT IN SYNC")
            }
            print(metric)
        }
        
        // TODO Force unwrap
        
    }
    
    func getConnectUIConfiguration() -> ConnectUIConfiguration? {
        return self.connectUiConfig
    }
    
    func getAuthMetrics() -> AuthMetrics? {
        return self.authMetrics
    }
}
