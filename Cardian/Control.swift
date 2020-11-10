//
//  Control.swift
//  Cardian
//
//  Created by Owen Sullivan on 11/4/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import Alamofire

public class Control {
    let queue = DispatchQueue(label: "com.curaegis.cardian")
    public static let `default` = Control();
    private var fetchingConfig: Bool
    public init() {
        self.config = nil;
        self.fetchingConfig = false;
    }
    
    private var config: CardianConfiguration?;
    
    public func configure(_ api_key: String) {
        print("Yessir")
        self.fetchingConfig = true;
        // Checck for a cached one under this API KEY
        API.getConfig(api_key, callback: self.setConfigurations);
    }
    
    private func setConfigurations(config: CardianConfiguration, uiConfig: ConnectUIConfiguration) {
        self.config = config;
        self.fetchingConfig = false;
    }
}
