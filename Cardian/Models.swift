//
//  Models.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/10/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation

struct CardianConfiguration: Codable {
    let metrics: String
    let appName: String
    let completion: String
    let themeIconUrl: String
    let themePrimaryColor: String // might be a hex or something other
}

struct AuthMetrics: Codable {
    let read: [Metric]
    let write: [Metric]
}

struct Metric: Codable {
    let name: String
    let displayName: String
    let type: String
    let description: String?
}

struct MetricCollection: Codable {
    let name: String
    let metrics: [Metric]
}


struct ConnectUIConfiguration {
    let cardianUrl: String
    
    // Introduction Screen Variables
    let introductionHeader: String
    let introductionTitle1: String
    let introductionBody1: String
    let introductionTitle2: String
    let introductionBody2: String
    let introductionButtonLabel: String
    
    // Usage Screen Variables
    let usageTitle: String
    let usageDescription: String
    let usageButtonLabel: String
    // Completion Screen Variables
    let completionTitle: String
    let completionBody: String
    let completionButtonLabel: String
    
    let authMetrics: AuthMetrics
    let metricCollections: [MetricCollection]
//    "metrics": {
//      "height": {
//        "label": "Height",
//        "mode": 0
//      }
}
