//
//  AuthManager.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/16/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import HealthKit

// MARK: Declarations
enum HealthKitAuthError: Error {
    case deviceNotSupported
    case unkonwn
}

class AuthManager {
    
    public static func authorize(authMetrics: AuthMetrics, completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitAuthError.deviceNotSupported)
            return
        }
        
        var writeMetrics: Set<HKSampleType> = Set<HKSampleType>()
        var readMetrics: Set<HKObjectType> = Set<HKObjectType>()
        
        for metric in authMetrics.write {
            guard let hkObject = HealthKitManager.healthKitObjectTranslater(metric: metric) else { continue }
            guard let hkObjectSampleType = hkObject as? HKSampleType else { continue }
            writeMetrics.insert(hkObjectSampleType)
        }
        
        for metric in authMetrics.read {
            guard let hkObject = HealthKitManager.healthKitObjectTranslater(metric: metric) else { continue }
            readMetrics.insert(hkObject)
        }
        
        HKHealthStore().requestAuthorization(toShare: writeMetrics, read: readMetrics) { (success, error) in
            completion(success, error)
        }
    }
}
