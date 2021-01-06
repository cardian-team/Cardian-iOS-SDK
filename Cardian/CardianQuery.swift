//
//  CardianQuery.swift
//  Cardian
//
//  Created by Owen Sullivan on 1/6/21.
//  Copyright © 2021 Curaegis. All rights reserved.
//

import Foundation

public enum QueryField: String, Codable {
    case value
    case startTime = "start_time"
    case endTime = "end_time"
}

public enum QueryOrderDirection: String, Codable {
    case ascending = "asc"
    case descending = "dsc"
}

public struct QueryOrder: Codable {
    let field: QueryField
    let direction: QueryOrderDirection
}

public enum QueryConditionOperator: String, Codable {
    case lessThan, lessThanEqual, greaterThan, greaterThanEqual, equals
}

public struct QueryCondition: Codable {
    let field: QueryField
    let conditionOperator: QueryConditionOperator
    let value: Int // TODO make this a dynamic type
    
    enum CodingKeys: String, CodingKey {
        case conditionOperator = "operator"
        case field = "name"
        case value
    }
}

public enum QueryConditionalStatementType: String, Codable {
    case multiple = "multi"
    case single
}
public enum QueryConditionalStatementAppendType: String, Codable {
    case and
    case or
}
    
public struct QueryConditionalStatement: Codable {
    let type: QueryConditionalStatementType
    let append: QueryConditionalStatementAppendType
    let condition: QueryCondition
}

public struct CodableQuery: Codable {
    var metric: CardianMetricIdentifier
    var fields: [QueryField] = []
    var conditionals: [QueryConditionalStatement]? = nil
    var order: QueryOrder? = nil
    var limit: Int = 1000
}


public class CardianQuery {
    var queryStructure: CodableQuery
    
    public init(metric: CardianMetricIdentifier) {
        self.queryStructure = CodableQuery(metric: metric)
    }
    
    public func whereSingle() {
        let conditions = [QueryConditionalStatement(type: .single, append: .and, condition: QueryCondition(field: .value, conditionOperator: .greaterThanEqual, value: 60))]
        self.queryStructure.conditionals = conditions
    }
    
    public func select(fields: [QueryField]) {
        self.queryStructure.fields = fields
    }
    
    public func orderBy(field: QueryField, direction: QueryOrderDirection) {
        self.queryStructure.order = QueryOrder(field: field, direction: direction)
    }
    
    public func limitedBy(limit: Int) {
        self.queryStructure.limit = limit
    }

    public func getCodableQuery() -> CodableQuery {
        return self.queryStructure
    }
}
