//
//  Habit+CoreDataProperties.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import CoreData
import Foundation


@objc(Habit)
public class Habit: NSManagedObject {

}

extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var streakCount: Int64
    @NSManaged public var lastCompleted: Date?
    @NSManaged public var completionDates: [Date]?
    @NSManaged public var themeRawValue: String?
    @NSManaged public var iconName: String?
    @NSManaged public var isPinned: Bool
    
 
    @NSManaged public var isNotificationEnabled: Bool
    @NSManaged public var notificationTime: Date?
    
    // MARK: - SwiftUI Kolay Erişim
    var theme: HabitTheme {
        return HabitTheme(rawValue: themeRawValue ?? "health") ?? .health
    }
}

extension Habit: Identifiable {}


