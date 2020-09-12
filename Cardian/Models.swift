//
//  Models.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/10/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation

struct AuthMetrics: Codable {
    let read: [String]
    let write: [String]
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

