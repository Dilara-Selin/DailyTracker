//
//  HabitTheme.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

// HabitTheme.swift

import SwiftUI // Color kullanmak için gerekli

enum HabitTheme: String, CaseIterable, Identifiable {
    case health
    case mind
    case work
    case finance
    case social
    case home
    
    var id: String { self.rawValue }
    
   
    var iconName: String {
        switch self {
        case .health:
            return "heart.fill"
        case .mind:
            return "brain.head.profile"
        case .work:
            return "laptopcomputer"
        case .finance:
            return "dollarsign.circle.fill"
        case .social:
            return "person.3.fill"
        case .home:
            return "house.fill"
        }
    }
    

    var color: Color {
        switch self {
        case .health:
            return .red
        case .mind:
            return .purple
        case .work:
            return .blue
        case .finance:
            return .green
        case .social:
            return .orange
        case .home:
            return .brown
        }
    }
}
