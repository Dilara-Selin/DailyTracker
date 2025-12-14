//
//  DateArrayTransformer.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 11.12.2025.
//

import Foundation


@objc(DateArrayTransformer)
final class DateArrayTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(rawValue: "DateArrayTransformer")

 
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSDate.self, NSMutableArray.self]
    }
    
 
    override static func allowsReverseTransformation() -> Bool {
        return true
    }
    

    public static func register() {
     
        let transformer = DateArrayTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
