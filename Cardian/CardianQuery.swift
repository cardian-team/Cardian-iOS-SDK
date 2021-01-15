//
//  CardianQuery.swift
//  Cardian
//
//  Created by Owen Sullivan on 1/6/21.
//  Copyright © 2021 Curaegis. All rights reserved.
//

import Foundation

public enum CardianQueryScope: Int, Codable {
    case individual = 1
    case summary = 2
    case group = 3
}

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
    let value: String // TODO make this a dynamic type
    
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
    var scope: CardianQueryScope
    var metric: CardianMetricIdentifier
    var fields: [QueryField] = []
    var conditionals: [QueryConditionalStatement] = []
    var order: QueryOrder? = nil
    var limit: Int = 1000
}


public class CardianQuery {
    var queryStructure: CodableQuery
    
    public init(scope: CardianQueryScope, metric: CardianMetricIdentifier) {
        self.queryStructure = CodableQuery(scope: scope, metric: metric)
    }
    
    // TODO Add Where for Multi conditionals
    
    
    
    
    public func whereSingle(startTime value: TimeInterval, op: QueryConditionOperator, append: QueryConditionalStatementAppendType) -> Self {
        let condition = QueryConditionalStatement(type: .single, append: append, condition: QueryCondition(field: .startTime, conditionOperator: op, value: String(value)))
        self.queryStructure.conditionals.append(condition)
        return self
    }
    
    public func whereSingle(endTime value: TimeInterval, op: QueryConditionOperator, append: QueryConditionalStatementAppendType) -> Self {
        let condition = QueryConditionalStatement(type: .single, append: append, condition: QueryCondition(field: .endTime, conditionOperator: op, value: String(value)))
        self.queryStructure.conditionals.append(condition)
        return self
    }
    
    public func whereSingle(recordValue value: Double, op: QueryConditionOperator, append: QueryConditionalStatementAppendType) -> Self {
        let condition = QueryConditionalStatement(type: .single, append: append, condition: QueryCondition(field: .value, conditionOperator: op, value: String(value)))
        self.queryStructure.conditionals.append(condition)
        return self
    }

    
    public func select(fields: [QueryField]) -> Self {
        self.queryStructure.fields = fields
        return self
    }
    
    public func orderBy(field: QueryField, direction: QueryOrderDirection) -> Self {
        self.queryStructure.order = QueryOrder(field: field, direction: direction)
        return self
    }
    
    public func limitedBy(limit: Int) -> Self {
        self.queryStructure.limit = limit
        return self
    }

    public func getCodableQuery() -> CodableQuery {
        return self.queryStructure
    }
}
