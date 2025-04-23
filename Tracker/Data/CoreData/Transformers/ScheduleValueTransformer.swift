//
//  ScheduleValueTransformer.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import Foundation

class ScheduleValueTransformer: ValueTransformer {
    
    static func register() {
        let transformer = ScheduleValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("ScheduleValueTransformer"))
    }
    
    override class func transformedValueClass() -> AnyClass {
        NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let schedule = value as? [Day] else { return nil }
        let dayNumbers = schedule.map { $0.rawValue }
        let string = dayNumbers.map { String($0) }.joined(separator: ",")
        return string.data(using: .utf8)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data,
              let stringValue = String(data: data, encoding: .utf8) else { return nil }
        let dayNumbers = stringValue.split(separator: ",").compactMap { Int($0) }
        return dayNumbers.compactMap { Day(rawValue: $0) }
    }
}




