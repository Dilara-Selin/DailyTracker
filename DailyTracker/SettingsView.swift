//
//  SettingsView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
  
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    var body: some View {
        NavigationStack {
            ZStack {
               
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        
                        SettingsGroup(title: "Görünüm") {
                            SettingsRow(icon: "moon.fill", iconColor: .purple, title: "Karanlık Mod") {
                                Toggle("", isOn: $isDarkMode)
                                    .labelsHidden()
                            }
                        }
                        
                        
                        SettingsGroup(title: "Veri & Yönetim") {
                            SettingsRow(icon: "arrow.counterclockwise", iconColor: .blue, title: "Tanıtımı Tekrar Göster") {
                                Button("Sıfırla") {
                                    isOnboarding = true
                                }
                                .font(.subheadline)
                                .buttonStyle(.bordered)
                            }
                        }
                        
                    
                        SettingsGroup(title: "Hakkında") {
                            SettingsRow(icon: "info.circle.fill", iconColor: .orange, title: "Versiyon") {
                                Text(appVersion)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            
                            SettingsRow(icon: "link", iconColor: .green, title: "Geliştirici") {
                                Link(destination: URL(string: "https://github.com/Dilara-Selin")!) {
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                      
                        VStack(spacing: 5) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("Daily Tracker © 2025")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Designed with in SwiftUI")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.large)
        }
     
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - YARDIMCI BİLEŞENLER


struct SettingsGroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 8)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}


struct SettingsRow<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let trailing: Content
    
    init(icon: String, iconColor: Color, title: String, @ViewBuilder trailing: () -> Content) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack(spacing: 15) {
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            trailing
        }
        .padding()
       
    }
}
