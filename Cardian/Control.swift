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
    private var config: CardianConfiguration?
    private var connectUiConfig: ConnectUIConfiguration?
    private var connectionClosure: ((ConnectUIConfiguration) -> Void)?
    public init() {
        self.config = nil;
        self.fetchingConfig = false;
        self.connectionClosure = nil;
    }
    
    
    public func configure(_ api_key: String) {
        print("Yessir")
        self.fetchingConfig = true;
        // Checck for a cached one under this API KEY
        API.getConfig(api_key, callback: self.setConfigurations);
    }
    
    private func setConfigurations(config: CardianConfiguration, uiConfig: ConnectUIConfiguration) {
        print("Set configurations")
        self.config = config;
        self.connectUiConfig = uiConfig;
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
    
    func getConnectUIConfiguration() -> ConnectUIConfiguration? {
        return self.connectUiConfig
    }
}
