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
    var append: QueryConditionalStatementAppendType? = nil
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
    var condition: QueryCondition? = nil
    var conditions: [QueryCondition]? = nil
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
    
    public func whereMulti(fields: [QueryField], values: [Any], ops: [QueryConditionOperator], appends: [QueryConditionalStatementAppendType], finalAppend: QueryConditionalStatementAppendType) -> Self {
        let count = fields.count;
        if (values.count != count || ops.count != count || appends.count != count) {
            print("Cardian Error [whereMulti]: Make sure that all parameters are the same length")
            return self;
        }
        
        var conditions: [QueryCondition] = []
        
        for n in 0...(count - 1
        ) {
            switch fields[n] {
            case .endTime, .startTime:
                if let timeInterval = values[n] as? TimeInterval {
                    conditions.append(QueryCondition(field: fields[n], conditionOperator: ops[n], append: appends[n], value: String(timeInterval)))
                } else {
                    print("Cardian Error [whereMulti]: the field 'endTime/startTime' must have value type TimeInterval")
                    return self;
                }
            
            case .value:
                if let doubleValue = values[n] as? Double {
                    conditions.append(QueryCondition(field: fields[n], conditionOperator: ops[n], append: appends[n], value: String(doubleValue)))
                } else {
                    print("Cardian Error [whereMulti]: the field 'value' must have value type Double")
                    return self;
                }
            }
        }
        
        let conditionalStatement = QueryConditionalStatement(type: .multiple, append: finalAppend, condition: nil, conditions: conditions)
        
        self.queryStructure.conditionals.append(conditionalStatement)
        return self
    }
    
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
