//
//  HealthKitManager.swift
//  app
//
//  Created by Mitchell Sweet on 5/19/20.
//  Copyright © 2020 CurAegis. All rights reserved.
//

import Foundation
import HealthKit

// MARK: Declarations
/// Stores step data for JSON export
struct GenericHealthKitRecord : Codable {
    var start_time: Double
    var end_time: Double
    var count: Double
    var reference_id: UUID
    var source: String = "h"
}

/// Sleep record types
enum SleepRecordType : Int {
    case ASLEEP = 0
    case IN_BED = 1
    case AWAKE  = 2
}

/// Calorie record types
enum CalorieRecordType : Int {
    case BASAL = 0
    case ACTIVE = 1
}

enum HealthDataType {
    case sleep
    case height
    case weight
}

enum HealthGender: Int {
    case male = 0
    case female = 1
    case other = 2
    case notSet = -9999
}

/// Stores sleep data for JSON export
struct SleepData: Codable {
    var start_time: Double
    var end_time: Double
    var type: Int
    var reference_id: UUID
    var source: String = "h"
}

/// Stores calorie data for JSON export
struct CalorieData: Codable {
    var start_time: Double
    var end_time: Double
    var count: Double
    var type: Int
    var reference_id: UUID
    var source: String = "h"
}

struct HealthBirthdate {
    let year: Int?
    let month: Int?
    let day: Int?
}

// MARK: Class
class HealthKitManager {
    
    public static func healthKitObjectTranslater(metric: Metric) -> HKObjectType? {
        switch metric.name {
        case "height":
                return HKQuantityType.quantityType(forIdentifier: .height)
        case "weight":
                return HKQuantityType.quantityType(forIdentifier: .bodyMass)
        case "heartRate":
                return HKQuantityType.quantityType(forIdentifier: .heartRate)
        case "bodyTemperature":
                return HKQuantityType.quantityType(forIdentifier: .bodyTemperature)
        case "oxygenSaturation":
                return HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)
        case "bloodPressureDiasystolic":
                return HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)
        case "bloodPressureSystolic":
                return HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)
        case "bodyFatPercentage":
            return HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)
        case "bloodGlucose":
            return HKQuantityType.quantityType(forIdentifier: .bloodGlucose)
        case "stepCount":
            return HKQuantityType.quantityType(forIdentifier: .stepCount)
        case "distanceWalkingRunning":
            return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        case "distanceCycling":
            return HKQuantityType.quantityType(forIdentifier: .distanceCycling)
        case "basalEnergyBurned":
            return HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)
        case "activeEnergyBurned":
            return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        case "flightsClimbed":
            return HKQuantityType.quantityType(forIdentifier: .flightsClimbed)
        case "sleepAnalysis":
            return HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
        case "workouts":
            return HKObjectType.workoutType()
        case "uvExposure":
            return HKQuantityType.quantityType(forIdentifier: .uvExposure)
        case "biologicalSex":
            return HKCharacteristicType.characteristicType(forIdentifier: .biologicalSex)
        case "dateOfBirth":
            return HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth)
        case "menstrualFlow":
            return HKCategoryType.categoryType(forIdentifier: .menstrualFlow)
        case "cervicalMucusQuality":
            return HKCategoryType.categoryType(forIdentifier: .cervicalMucusQuality)
        case "basalBodyTemperature":
            return HKQuantityType.quantityType(forIdentifier: .basalBodyTemperature)
        case "ovulationTestResults":
            return HKCategoryType.categoryType(forIdentifier: .ovulationTestResult)
        default:
            print("Health metric either not supported or found.")
            return nil
        }
    }
    
    /// Returns whether health data is available on this device.
    public static func dataAvailable() -> Bool { return HKHealthStore.isHealthDataAvailable() }
    
    /// Determines if a specific type of data is authorized for us to write to.  Options are: sleep, height, weight
    public static func isAuthorizedToWrite(type: HealthDataType) -> Bool {
        guard dataAvailable() else { return false }
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        switch type {
        case .sleep:
            guard let field = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return false }
            let authorized = HKHealthStore().authorizationStatus(for: field)
            guard authorized != HKAuthorizationStatus.notDetermined && authorized != HKAuthorizationStatus.sharingDenied else { return false }
            return true
        case .height:
            guard let field = HKObjectType.quantityType(forIdentifier: .height) else { return false }
            let authorized = HKHealthStore().authorizationStatus(for: field)
            guard authorized != HKAuthorizationStatus.notDetermined && authorized != HKAuthorizationStatus.sharingDenied else { return false }
            return true
        case .weight:
            guard let field = HKObjectType.quantityType(forIdentifier: .bodyMass) else { return false }
            let authorized = HKHealthStore().authorizationStatus(for: field)
            guard authorized != HKAuthorizationStatus.notDetermined && authorized != HKAuthorizationStatus.sharingDenied else { return false }
            return true
        }
    }
    
    /// Gets the date of birth for the user from HealthKit
    public static func getDateOfBirth() -> DateComponents? {
        guard dataAvailable() else { return nil }
        do {
            let dob = try HKHealthStore().dateOfBirthComponents()
            return dob
        } catch {
            return nil
        }
    }
    
    /**
     Returns the gender from healthkit
     0=Male
     1=Female
     2=Other
     -9999=Not Set
     */
    public static func getGender() -> HealthGender? {
        guard dataAvailable() else { return nil }
        do {
            let gender = try HKHealthStore().biologicalSex()
            switch (gender.biologicalSex) {
            case HKBiologicalSex.notSet:
                return .notSet
            case HKBiologicalSex.male:
                return .male
            case HKBiologicalSex.female:
                return .female
            case HKBiologicalSex.other:
                return .other
            default:
                return .notSet
            }
        } catch {
            return nil
        }
    }
    
    private static func queryHealthKit(sampleType: HKSampleType, completion: @escaping (Any?) -> Void) {
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            guard error == nil else {
                print("Failed to get weight from HealthKit: \(error.debugDescription)")
                completion(nil)
                return
            }
            completion(results)
        }
        HKHealthStore().execute(query)
        
    }
    
    /// Returns the current weight from healthkit in pounds
    public static func getCurrentWeight(completion: @escaping (Double?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        guard let field = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            completion(nil)
            return
        }
        queryHealthKit(sampleType: field) { (results) in
            guard let samples = results as? [HKSample]?, let current = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            completion(current.quantity.doubleValue(for: HKUnit(from: MassFormatter.Unit.pound)))
        }
    }
    
    /// Returns the current height from healthkit in inches
    public static func getCurrentHeight(completion: @escaping (Double?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        guard let field = HKSampleType.quantityType(forIdentifier: .height) else {
            completion(nil)
            return
        }
        queryHealthKit(sampleType: field) { (results) in
            guard let samples = results as? [HKSample]?, let current = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            completion(current.quantity.doubleValue(for: HKUnit(from: LengthFormatter.Unit.inch)))
        }
    }
    
    /// Returns step count from healthkit based on an interval of start/end timestamps
    public static func getSteps(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([GenericHealthKitRecord]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        guard let field = HKSampleType.quantityType(forIdentifier: .stepCount) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get steps from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [GenericHealthKitRecord]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                let step = GenericHealthKitRecord(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit.count()),
                    reference_id: s.uuid
                )
                out.append(step)
            }
            completion(out)
        }
        HKHealthStore().execute(query)
    }
    
    /// Returns the user's sleep analysis from healthkit on a start/end interval
    public static func getSleep(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([SleepData]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        guard let field = HKSampleType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get sleep analysis from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [SleepData]()
            for sample in samples {
                guard let s = sample as? HKCategorySample else { continue }
                var recordType = SleepRecordType.AWAKE.rawValue
                
                if (s.value == HKCategoryValueSleepAnalysis.asleep.rawValue) {
                    recordType = SleepRecordType.ASLEEP.rawValue
                } else if (s.value == HKCategoryValueSleepAnalysis.inBed.rawValue) {
                    recordType = SleepRecordType.IN_BED.rawValue
                }
                
                let sleep = SleepData(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    type: recordType,
                    reference_id: s.uuid
                )
                out.append(sleep)
            }
            completion(out)
        }
        HKHealthStore().execute(query)
    }
    
    public static func getActiveCalories(start: Date, end: Date, limit: Int = 25000, completion: @escaping ([CalorieData]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        guard let field = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get breathing sessions from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [CalorieData]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                
                let activeCalorie = CalorieData(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit(from: EnergyFormatter.Unit.kilocalorie)),
                    type: CalorieRecordType.ACTIVE.rawValue,
                    reference_id: s.uuid
                )
                out.append(activeCalorie)
            }
            completion(out)
        }
        HKHealthStore().execute(query)
    }
    
    /// Returhs the calorie data from healthkit
    public static func getCalories(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([CalorieData]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        guard let basalField = HKSampleType.quantityType(forIdentifier: .basalEnergyBurned) else {
            completion(nil)
            return
        }
        
        guard let activeField = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil)
            return
        }
        
        // Query for the basal calorie data
        let basalQuery = HKSampleQuery(sampleType: basalField, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get basal calories from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [CalorieData]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                
                let basalCalorie = CalorieData(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit(from: EnergyFormatter.Unit.kilocalorie)),
                    type: CalorieRecordType.BASAL.rawValue,
                    reference_id: s.uuid
                )
                out.append(basalCalorie)
            }
            
            // Query for the active calories data
            let activeQuery = HKSampleQuery(sampleType: activeField, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
                
                guard error == nil else {
                    print("Failed to get active calories from healthkit: \(error.debugDescription)")
                    completion(nil)
                    return
                }
                
                guard let samples = results else {
                    completion(nil)
                    return
                }
                
                for sample in samples {
                    guard let s = sample as? HKQuantitySample else { continue }
                    
                    let activeCalorie = CalorieData(
                        start_time: s.startDate.timeIntervalSince1970,
                        end_time: s.endDate.timeIntervalSince1970,
                        count: s.quantity.doubleValue(for: HKUnit(from: EnergyFormatter.Unit.kilocalorie)),
                        type: CalorieRecordType.ACTIVE.rawValue,
                        reference_id: s.uuid
                    )
                    out.append(activeCalorie)
                }
                completion(out)
            }
            HKHealthStore().execute(activeQuery)
        }
        HKHealthStore().execute(basalQuery)
    }
    
    /// Returns heart rate data on a start/end interval from HealthKit
    public static func getHeartRate(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([GenericHealthKitRecord]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
    
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        guard let field = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get heart rate data from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [GenericHealthKitRecord]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                
                let heartRate = GenericHealthKitRecord(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit.init(from: "count/min")),
                    reference_id: s.uuid
                )
                
                out.append(heartRate)
            }
            completion(out)
        }
        HKHealthStore().execute(query)
    }
    
    /// Returns heart rate variability data on a start/end interval from healthkit
    public static func getHeartRateVariability(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([GenericHealthKitRecord]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        guard let field = HKSampleType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get heart rate variabliity data from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [GenericHealthKitRecord]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                
                let hrv = GenericHealthKitRecord(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)),
                    reference_id: s.uuid
                )
                out.append(hrv)
            }
            completion(out)
        }
        HKHealthStore().execute(query)
    }

    /// Returns the exercise minutes for a given start/stop interval in minutes
    public static func getExercise(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([GenericHealthKitRecord]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        guard let field = HKSampleType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get exercise minutes from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }

            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [GenericHealthKitRecord]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                
                let exercise = GenericHealthKitRecord(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit.minute()),
                    reference_id: s.uuid
                )
                out.append(exercise)
            }
           completion(out)
        }
        HKHealthStore().execute(query)
    }
    
    /// Returns the exercise minutes for a given start/stop interval in minutes
    public static func getBreathingSessions(start: Date, end: Date, limit: Int = 250000, completion: @escaping ([GenericHealthKitRecord]?) -> Void) {
        guard dataAvailable() else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        guard let field = HKSampleType.categoryType(forIdentifier: .mindfulSession) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get breathing sessions from healthkit: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            guard let samples = results else {
                completion(nil)
                return
            }
            
            var out = [GenericHealthKitRecord]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                
                let breathingSession = GenericHealthKitRecord(
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    count: s.quantity.doubleValue(for: HKUnit.minute()),
                    reference_id: s.uuid
                )
                out.append(breathingSession)
            }
            completion(out)
        }
        HKHealthStore().execute(query)
    }

    public static func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }

        HKHealthStore().execute(query)
    }
}
