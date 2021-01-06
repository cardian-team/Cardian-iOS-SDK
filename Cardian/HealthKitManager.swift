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
enum MetricSchemaType : Int, Codable {
    case quantitative = 1
    case attribute = 2
    case sleep = 3
    case structured_activity = 4
}

// TODO clean this
enum CardianMetricIdentifier : Int, Codable {
    case empty,height,weight,heartRate,bodyTemperature,oxygenSaturation,bloodPressureDiasystolic,bloodPressureSystolic,bodyFatPercentage,bloodGlucose,stepCount,distanceWalkingRunning,distanceCycling,basalEnergyBurned,activeEnergyBurned,flightsClimbed,sleepAnalysis,workouts,uvExposure,biologicalSex,dateOfBirth,menstrualFlow,cervicalMucusQuality,basalBodyTemperature,ovulationTestResults
}

struct CardianRecord : Codable {
    var metric_schema_type: MetricSchemaType
    var quantitiy: QuantitativeCardianRecord
}

/// Stores step data for JSON export
struct QuantitativeCardianRecord : Codable {
    var metric_type: CardianMetricIdentifier
    var start_time: Double
    var end_time: Double
    var value: Double
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

struct HealthBirthdate {
    let year: Int?
    let month: Int?
    let day: Int?
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

// MARK: Class
class HealthKitManager {
    public static func healthKitObjectTranslater(metric: Metric) -> HKObjectType? {
        switch metric.id {
        case CardianMetricIdentifier.height:
                return HKQuantityType.quantityType(forIdentifier: .height)
        case CardianMetricIdentifier.weight:
                return HKQuantityType.quantityType(forIdentifier: .bodyMass)
        case CardianMetricIdentifier.heartRate:
                return HKQuantityType.quantityType(forIdentifier: .heartRate)
        case CardianMetricIdentifier.bodyTemperature:
                return HKQuantityType.quantityType(forIdentifier: .bodyTemperature)
        case CardianMetricIdentifier.oxygenSaturation:
                return HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)
        case CardianMetricIdentifier.bloodPressureDiasystolic:
                return HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)
        case CardianMetricIdentifier.bloodPressureSystolic:
                return HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)
        case CardianMetricIdentifier.bodyFatPercentage:
            return HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)
        case CardianMetricIdentifier.bloodGlucose:
            return HKQuantityType.quantityType(forIdentifier: .bloodGlucose)
        case CardianMetricIdentifier.stepCount:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)
        case CardianMetricIdentifier.distanceWalkingRunning:
            return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        case CardianMetricIdentifier.distanceCycling:
            return HKQuantityType.quantityType(forIdentifier: .distanceCycling)
        case CardianMetricIdentifier.basalEnergyBurned:
            return HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)
        case CardianMetricIdentifier.activeEnergyBurned:
            return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        case CardianMetricIdentifier.flightsClimbed:
            return HKQuantityType.quantityType(forIdentifier: .flightsClimbed)
        case CardianMetricIdentifier.sleepAnalysis:
            return HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
        case CardianMetricIdentifier.workouts:
            return HKObjectType.workoutType()
        case CardianMetricIdentifier.uvExposure:
            return HKQuantityType.quantityType(forIdentifier: .uvExposure)
        case CardianMetricIdentifier.biologicalSex:
            return HKCharacteristicType.characteristicType(forIdentifier: .biologicalSex)
        case CardianMetricIdentifier.dateOfBirth:
            return HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth)
        case CardianMetricIdentifier.menstrualFlow:
            return HKCategoryType.categoryType(forIdentifier: .menstrualFlow)
        case CardianMetricIdentifier.cervicalMucusQuality:
            return HKCategoryType.categoryType(forIdentifier: .cervicalMucusQuality)
        case CardianMetricIdentifier.basalBodyTemperature:
            return HKQuantityType.quantityType(forIdentifier: .basalBodyTemperature)
        case CardianMetricIdentifier.ovulationTestResults:
            return HKCategoryType.categoryType(forIdentifier: .ovulationTestResult)
        default:
            print("Health metric either not supported or found.")
            return nil
        }
    }
    
    public static func getHealthKitRecords(metric: Metric, start: Date, end: Date, completion: @escaping ([CardianRecord]?, MetricSchemaType?) -> Void) {
        switch metric.type {
        case .quantitative:
            var identifier: HKSampleType?
            var unit = HKUnit.count()
            switch metric.id {
            case CardianMetricIdentifier.height:
                identifier = HKSampleType.quantityType(forIdentifier: .height)
                unit = HKUnit(from: LengthFormatter.Unit.inch)
            case CardianMetricIdentifier.weight:
                identifier = HKSampleType.quantityType(forIdentifier: .bodyMass)
                unit = HKUnit(from: MassFormatter.Unit.pound)
            case CardianMetricIdentifier.heartRate:
                identifier = HKSampleType.quantityType(forIdentifier: .heartRate)
                unit = HKUnit.init(from: "count/min")
            case CardianMetricIdentifier.bodyTemperature:
                identifier = HKSampleType.quantityType(forIdentifier: .bodyTemperature)
            case CardianMetricIdentifier.oxygenSaturation:
                identifier = HKSampleType.quantityType(forIdentifier: .oxygenSaturation)
            case CardianMetricIdentifier.bloodPressureDiasystolic:
                identifier = HKSampleType.quantityType(forIdentifier: .bloodPressureDiastolic)
            case CardianMetricIdentifier.bloodPressureSystolic:
                identifier = HKSampleType.quantityType(forIdentifier: .bloodPressureSystolic)
            case CardianMetricIdentifier.bodyFatPercentage:
                identifier = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)
            case CardianMetricIdentifier.bloodGlucose:
                identifier = HKSampleType.quantityType(forIdentifier: .bloodGlucose)
            case CardianMetricIdentifier.stepCount:
                identifier = HKSampleType.quantityType(forIdentifier: .stepCount)
                unit = HKUnit.count()
            case CardianMetricIdentifier.distanceWalkingRunning:
                identifier = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
            case CardianMetricIdentifier.distanceCycling:
                identifier = HKSampleType.quantityType(forIdentifier: .distanceCycling)
            case CardianMetricIdentifier.basalEnergyBurned:
                identifier = HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)
                unit = HKUnit(from: EnergyFormatter.Unit.kilocalorie)
            case CardianMetricIdentifier.activeEnergyBurned:
                identifier = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)
                unit = HKUnit(from: EnergyFormatter.Unit.kilocalorie)
            case CardianMetricIdentifier.flightsClimbed:
                identifier = HKSampleType.quantityType(forIdentifier: .flightsClimbed)
            case CardianMetricIdentifier.uvExposure:
                identifier = HKSampleType.quantityType(forIdentifier: .uvExposure)
            case CardianMetricIdentifier.basalBodyTemperature:
                identifier = HKSampleType.quantityType(forIdentifier: .basalBodyTemperature)
            default:
                completion(nil, nil)
            }
            getQuantitativeMetric(metric: metric, field: identifier!, unit: unit, start: start, end: end, completion: completion)
        case .attribute:
            completion(nil, nil)
        case .sleep:
            completion(nil, nil)
        case .structured_activity:
            completion(nil, nil)
        }
    }
    
    
    
    /// Returns whether health data is available on this device.
    public static func dataAvailable() -> Bool { return HKHealthStore.isHealthDataAvailable() }
    
    // TODO add all data points here?
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
    
    /// Returns step count from healthkit based on an interval of start/end timestamps
    public static func getQuantitativeMetric(metric: Metric, field: HKSampleType, unit: HKUnit, start: Date, end: Date, limit: Int = 250000, completion: @escaping ([CardianRecord]?, MetricSchemaType?) -> Void) {
        guard dataAvailable() else {
            completion(nil, nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: field, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            guard error == nil else {
                print("Failed to get steps from healthkit: \(error.debugDescription)")
                completion(nil, nil)
                return
            }
            
            guard let samples = results else {
                completion(nil, nil)
                return
            }
            
            var out = [CardianRecord]()
            for sample in samples {
                guard let s = sample as? HKQuantitySample else { continue }
                // Get the CARDIAN Type here not the raw value of HK type
                let quantitativeRecord = QuantitativeCardianRecord(
                    metric_type: metric.id,
                    start_time: s.startDate.timeIntervalSince1970,
                    end_time: s.endDate.timeIntervalSince1970,
                    value: s.quantity.doubleValue(for: unit),
                    reference_id: s.uuid
                )
                let record = CardianRecord(metric_schema_type: .quantitative, quantitiy: quantitativeRecord)
                out.append(record)
            }
            completion(out, MetricSchemaType.quantitative)
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
}
