//
//  Control.swift
//  Cardian
//
//  Created by Owen Sullivan on 11/4/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation

public class Control {
    public static let `default` = Control();
    public init() {}
    
    public func configure(_ api_key: String) {
        // Checck for a cached one under this API KEY
        
        API.getConfig(
            
        )
    }
    
    public func log(message: String) {
        print("Log message: ", message)
    }
}
