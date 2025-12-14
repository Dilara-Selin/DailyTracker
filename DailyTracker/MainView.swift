//
//  MainView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI

struct MainView: View {
 
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            
            TabView(selection: $selectedTab) {
                HabitListView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                
                ProfileView()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
                
                SettingsView()
                    .tag(2)
                    .toolbar(.hidden, for: .tabBar)
            }
            
   
            HStack {
                ForEach(0..<3) { index in
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                      
                            Image(systemName: iconName(for: index))
                                .font(.system(size: 24))
                                .symbolVariant(selectedTab == index ? .fill : .none)
                                .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                            
                            if selectedTab == index {
                                Text(tabName(for: index))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .foregroundColor(selectedTab == index ? .blue : .gray.opacity(0.6))
                        .frame(height: 50)
                    }
                    
                    Spacer()
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .cornerRadius(35)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 25)
            .padding(.bottom, 10)
        }
      
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    

    func iconName(for index: Int) -> String {
        switch index {
        case 0: return "checklist"
        case 1: return "person"
        case 2: return "gearshape"
        default: return ""
        }
    }
    
  
    func tabName(for index: Int) -> String {
        switch index {
        case 0: return "Takip"
        case 1: return "Profil"
        case 2: return "Ayarlar"
        default: return ""
        }
    }
}
