//
//  HabitDetailView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI
import Charts
import UserNotifications

struct HabitDetailView: View {
    
        @ObservedObject var habit: Habit
    
  
    @State private var tempDate: Date = Date()
    
    var body: some View {
        Form {
            // MARK: - 1. Bölüm: İstatistikler
            Section("Performans") {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Son 7 Günlük Grafik")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart(weeklyData) { daily in
                        BarMark(
                            x: .value("Gün", daily.day, unit: .day),
                            y: .value("Tamamlanma", daily.completed)
                        )
                        .foregroundStyle(daily.completed == 1 ? .green : .red.opacity(0.3))
                    }
                    .chartYAxis {
                        AxisMarks(values: [0, 1]) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let intValue = value.as(Int.self) {
                                    Text(intValue == 1 ? "Var" : "Yok")
                                }
                            }
                        }
                    }
                    .frame(height: 180)
                }
                .padding(.vertical, 5)
                
                HStack {
                    Text("Mevcut Seri (Streak):")
                    Spacer()
                    Text("\(habit.streakCount) Gün")
                        .bold()
                        .foregroundColor(.orange)
                }
            }
            
            // MARK: - 2. Bölüm: Bildirim Ayarları
            Section("Hatırlatıcı") {
                Toggle(isOn: Binding(
                    get: { habit.isNotificationEnabled },
                    set: { newValue in
                       
                        CoreDataManager.shared.updateNotificationSettings(
                            habit: habit,
                            isEnabled: newValue,
                            time: habit.notificationTime ?? Date()
                        )
                     
                        if newValue {
                            requestPermission()
                        }
                    }
                )) {
                    Label("Günlük Bildirim", systemImage: "bell.badge.fill")
                        .foregroundColor(habit.isNotificationEnabled ? .blue : .primary)
                }
                
             
                if habit.isNotificationEnabled {
                    DatePicker(
                        "Saat Seç",
                        selection: Binding(
                            get: { habit.notificationTime ?? Date() },
                            set: { newTime in
                               
                                CoreDataManager.shared.updateNotificationSettings(
                                    habit: habit,
                                    isEnabled: true,
                                    time: newTime
                                )
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.compact)
                }
            }
        }
        .navigationTitle(habit.title ?? "Detay")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Weekly Data Hesaplama
    var weeklyData: [DailyCompletion] {
        var data: [DailyCompletion] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let completedDays = (habit.completionDates ?? []).map { calendar.startOfDay(for: $0) }
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let isCompleted = completedDays.contains(date) ? 1 : 0
            data.append(DailyCompletion(day: date, completed: isCompleted))
        }
        return data.reversed()
    }
    
  
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if !granted {
                print("İzin verilmedi")
               
                DispatchQueue.main.async {
                    habit.isNotificationEnabled = false
                }
            }
        }
    }
}
