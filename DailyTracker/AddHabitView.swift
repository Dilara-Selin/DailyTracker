//
//  AddHabitView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI

struct AddHabitView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitListViewModel
    
    @State private var habitTitle: String = ""
    @State private var selectedTheme: HabitTheme = .health
    

    @State private var isNotificationEnabled: Bool = false
    @State private var notificationTime: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
             
                Section {
                    TextField("Alışkanlık başlığı (örn: Kitap Oku)", text: $habitTitle)
                }
                
               
                Section("Tema Seç") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(HabitTheme.allCases) { theme in
                                VStack {
                                    Image(systemName: theme.iconName)
                                        .font(.title2)
                                        .foregroundColor(theme.color)
                                        .frame(width: 44, height: 44)
                                        .background(theme.color.opacity(selectedTheme == theme ? 0.2 : 0.05))
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(selectedTheme == theme ? theme.color : Color.clear, lineWidth: 3)
                                        )
                                    Text(theme.rawValue.capitalized)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .onTapGesture {
                                    self.selectedTheme = theme
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                    .listRowSeparator(.hidden)
                }
                
                
                Section("Hatırlatıcı") {
                    Toggle(isOn: $isNotificationEnabled) {
                        Label("Günlük Bildirim", systemImage: "bell.badge.fill")
                            .foregroundColor(isNotificationEnabled ? .blue : .primary)
                    }
                    
                    if isNotificationEnabled {
                        DatePicker(
                            "Saat Seç",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                    }
                }
            }
            .navigationTitle("Yeni Alışkanlık")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveHabit()
                    }
                    .disabled(habitTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    // MARK: - Kaydetme Mantığı
    private func saveHabit() {
        guard !habitTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
      
        viewModel.manager.addHabit(
            title: habitTitle,
            lastCompleted: nil,
            streakCount: 0,
            themeRawValue: selectedTheme.rawValue,
            iconName: selectedTheme.iconName,
            // Bildirim bilgilerini gönderiyoruz
            isNotificationEnabled: isNotificationEnabled,
            notificationTime: isNotificationEnabled ? notificationTime : nil
        )
        
        
        if isNotificationEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
        

        viewModel.fetchHabits()
        dismiss()
    }
}
