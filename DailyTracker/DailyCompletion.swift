//
//  DailyCompletion.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

// DailyCompletion.swift


import Foundation


struct DailyCompletion: Identifiable {
    let id = UUID()
    let day: Date
    let completed: Int 
}
