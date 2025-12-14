//
//  DailyTrackerApp.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI
import UserNotifications

// MARK: - App Delegate (Bildirim Yönetimi İçin)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

@main
struct DailyTrackerApp: App {
  
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
  
    let coreDataManager = CoreDataManager.shared
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    init() {
     
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Bildirim izni onaylandı.")
            } else if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
        }
        
      
        DateArrayTransformer.register()
    }

    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                MainView()
                    .environment(\.managedObjectContext, coreDataManager.context)
            }
        }
    }
}
