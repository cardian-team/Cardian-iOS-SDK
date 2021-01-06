//
//  Models.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/10/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation

struct CardianConfiguration: Codable {
    let version: String
    let connectUi: ConnectUiConfiguration
    let interval: String = "week"
    let metrics: [Metric]
    
    enum CodingKeys: String, CodingKey {
        case connectUi = "connect_ui"
        
        case version
        case interval
        case metrics
    }
}

struct Metric: Codable {
    let label: String
    let type: String
    let usage_description: String?
    let id: CardianMetricIdentifier
    let mode: Int
}

struct ConnectUiConfiguration: Codable {
    let cardianUrl: String
    let iconUrl: String
    let appName: String
    let views: ConnectUiViews
    let colors: ConnectUiColors
    
    enum CodingKeys: String, CodingKey {
        case cardianUrl = "cardian_url"
        case iconUrl = "icon_url"
        case appName = "app_name"
        
        case views
        case colors
    }
}

struct ConnectUiViews: Codable {
    let introduction: ConnectUiIntroductionView
    let usage: ConnectUiUsageView
    let completion: ConnectUiCompletionView
}

struct ConnectUiIntroductionView: Codable {
    let title1: String
    let body1: String
    let title2: String
    let body2: String
    let buttonLabel: String
    
    enum CodingKeys: String, CodingKey {
        case title1 = "bullet_1_title"
        case body1 = "bullet_1_body"
        case title2 = "bullet_2_title"
        case body2 = "bullet_2_body"
        case buttonLabel = "button_label"
    }
}

struct ConnectUiUsageView: Codable {
    let title: String
    let description: String
    let buttonLabel: String
    
    enum CodingKeys: String, CodingKey {
        case buttonLabel = "button_label"
        
        case title
        case description
    }
}

struct ConnectUiCompletionView: Codable {
    let title: String
    let body: String
    let buttonLabel: String
    
    enum CodingKeys: String, CodingKey {
        case buttonLabel = "button_label"
        
        case title
        case body
    }
}

struct ConnectUiColors: Codable {
    let primary: String
}




struct AuthMetrics: Codable { // Remove and just find this programmatically..
    let read: [Metric]
    let write: [Metric]
}

struct MetricCollection: Codable {
    let name: String
    let metrics: [Metric]
}



struct ConnectedVersions: Codable {
    var versionsMap: [String: Bool]
    var latestConnectedVersion: String
}

