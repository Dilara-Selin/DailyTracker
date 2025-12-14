//
//  CoreDataManager.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//
// CoreDataManager.swift


import CoreData
import Foundation
import UserNotifications

class CoreDataManager: ObservableObject {
   
    static let shared = CoreDataManager()

    
    let container: NSPersistentContainer
    
   
    var context: NSManagedObjectContext {
        return container.viewContext
    }

    init(inMemory: Bool = false) {
      
        container = NSPersistentContainer(name: "DailyTracker")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
       
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Core Data yüklenemedi: \(error), \(error.userInfo)")
            }
            
            // MARK: - Test Verisi Eklenirken Senkronizasyon
            self.container.viewContext.performAndWait {
                self.createInitialHabits()
            }
        }
        
    
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Core Data Operations (CRUD)
    
    func save() {
       
        context.performAndWait {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                    print("Veri başarıyla kaydedildi ve senkronize edildi.")
                    // DispatchQueue.main.async bloğu artık burada gereksiz, silin!
                } catch {
                    let nsError = error as NSError
                    fatalError("Kaydedilemedi: \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
   
  
        func addHabit(title: String, lastCompleted: Date? = nil, streakCount: Int64 = 0, themeRawValue: String = "health", iconName: String = "heart.fill", isNotificationEnabled: Bool = false, notificationTime: Date? = nil) {
            
            let newHabit = Habit(context: context)
            newHabit.id = UUID()
            newHabit.title = title
            newHabit.dateCreated = Date()
            newHabit.streakCount = streakCount
            newHabit.lastCompleted = lastCompleted
            newHabit.themeRawValue = themeRawValue
            newHabit.iconName = iconName
            
       
            newHabit.isNotificationEnabled = isNotificationEnabled
            newHabit.notificationTime = notificationTime
            
            save()
            
         
            if isNotificationEnabled, let time = notificationTime {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: time)
                scheduleNotification(for: newHabit, at: components)
            }
        }
    func deleteHabit(offsets: IndexSet, habits: [Habit]) {
        offsets.map { habits[$0] }.forEach(context.delete)
        save()
    }
    
    // MARK: - Notification
    
    func scheduleNotification(for habit: Habit, at time: DateComponents) {
        
        guard let habitTitle = habit.title, let id = habit.id else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Unutma!"
        content.body = "\(habitTitle) alışkanlığını bugün tamamladın mı?"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim planlanamadı: \(error.localizedDescription)")
            } else {
                print("\(habitTitle) için bildirim planlandı.")
            }
        }
    }
    
    // MARK: - Test Verisi Oluşturma
    
    func createInitialHabits() {
       
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        if (try? context.count(for: request)) ?? 0 > 0 {
            return
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today),
              let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today) else {
            return
        }
        

        // MARK: - Test Senaryosu 1: Streak Devam Ediyor
       
        addHabit(title: "📖 Kitap Oku",
                 lastCompleted: yesterday,
                 streakCount: 1)

        // MARK: - Test Senaryosu 2: Streak Sıfırlanmalı
        
        addHabit(title: "💧 Su İç ",
                 lastCompleted: twoDaysAgo,
                 streakCount: 5,
                 themeRawValue: "finance", // Yeşil tema
                 iconName: "dollarsign.circle.fill")

        // MARK: - Test Senaryosu 3: Bugün Tamamlandı
     
        addHabit(title: "🧘 Meditasyon Yap ",
                 lastCompleted: today,
                 streakCount: 3,
                 themeRawValue: "mind",
                 iconName: "brain.head.profile")
    }
    


        func cancelNotification(for habit: Habit) {
            guard let id = habit.id?.uuidString else { return }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            print("Bildirim iptal edildi: \(habit.title ?? "")")
        }

        func updateNotificationSettings(habit: Habit, isEnabled: Bool, time: Date) {
           
            habit.isNotificationEnabled = isEnabled
            habit.notificationTime = time
            save()
            
            
            if isEnabled {
              
                cancelNotification(for: habit)
                
         
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: time)
                
             
                scheduleNotification(for: habit, at: components)
            } else {
              
                cancelNotification(for: habit)
            }
        }
}
