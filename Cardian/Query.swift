//
//  Query.swift
//  Cardian
//
//  Created by Owen Sullivan on 11/4/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation

public class Query {
    private var metric: String
    private var userIdentifier: String
    private var limit: Int
    
    init(userIdentifier: String, metric: String, limit: Int) {
        self.limit = limit
        self.userIdentifier = userIdentifier;
        self.metric = metric
    }
    
    func whereSingle() {
        
    }
    
    func whereMulti() {
        
    }
    
    func orderedBy() {
        
    }
}
