//
//  ProfileView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI
import CoreData
import PhotosUI

struct ProfileView: View {
   
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateCreated, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
  
    @AppStorage("userName") private var userName: String = "Kullanıcı"
    @AppStorage("userProfileImageData") private var userProfileImageData: Data?
    
  
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    // MARK: -  ROZET SİSTEMİ
    struct Badge: Identifiable {
        let id = UUID()
        let name: String
        let description: String
        let icon: String
        let color: Color
        let condition: (Int) -> Bool
    }
    
   
    let badges = [
        // 1
        Badge(name: "İlk Adım", description: "İlk alışkanlığını tamamla", icon: "figure.step.training", color: .blue, condition: { $0 >= 1 }),
        
        // 2 (YENİ)
        Badge(name: "Kararlı", description: "5 kez tamamla", icon: "checkmark.seal.fill", color: .green, condition: { $0 >= 5 }),
        
        // 3
        Badge(name: "Isınma Turu", description: "10 kez tamamla", icon: "flame.fill", color: .orange, condition: { $0 >= 10 }),
        
        // 4
        Badge(name: "Çeyrek Dalya", description: "25 kez tamamla", icon: "star.circle.fill", color: .mint, condition: { $0 >= 25 }),
        
        // 5
        Badge(name: "Alışkanlık Avcısı", description: "50 kez tamamla", icon: "target", color: .cyan, condition: { $0 >= 50 }),
        
        // 6
        Badge(name: "Yüzler Kulübü", description: "100 kez tamamla", icon: "trophy.circle.fill", color: .purple, condition: { $0 >= 100 }),
        
        // 7
        Badge(name: "Usta", description: "250 kez tamamla", icon: "medal.fill", color: .yellow, condition: { $0 >= 250 }),
        
        // 8
        Badge(name: "Efsane", description: "500 kez tamamla", icon: "crown.fill", color: .red, condition: { $0 >= 500 }),
        
        // 9 (YENİ - Final Hedefi)
        Badge(name: "Mitolojik", description: "1000 kez tamamla", icon: "infinity.circle.fill", color: .indigo, condition: { $0 >= 1000 })
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
              
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // MARK: - 1. Profil Başlığı (Avatar & İsim)
                        VStack(spacing: 15) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                ZStack {
                                    // Profil Resmi veya Placeholder
                                    if let data = userProfileImageData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    } else {
                                        Circle()
                                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 120, height: 120)
                                            .overlay(
                                                Text(String(userName.prefix(1)).uppercased())
                                                    .font(.system(size: 50, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                            .shadow(radius: 5)
                                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    }
                                    
                                 
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Circle().fill(Color.blue))
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .offset(x: 40, y: 40)
                                }
                            }
                            .onChange(of: selectedItem) { oldValue, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data),
                                       let compressedData = uiImage.jpegData(compressionQuality: 0.5) {
                                        userProfileImageData = compressedData
                                    }
                                }
                            }
                            
                          
                            VStack(spacing: 5) {
                                TextField("İsim Giriniz", text: $userName)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .submitLabel(.done)
                                
                                Text("Toplam \(totalCompletions) Tamamlama")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.secondary.opacity(0.1)))
                            }
                        }
                        .padding(.top, 20)
                        
                        // MARK: - 2. İstatistik Kartları
                        HStack(spacing: 15) {
                            StatCard(title: "Alışkanlıklar", value: "\(habits.count)", icon: "list.bullet.rectangle.portrait.fill", color: .blue)
                            StatCard(title: "En İyi Seri", value: "\(bestStreak)", icon: "flame.fill", color: .orange)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - 3. Rozet Koleksiyonu (3 Sütunlu Grid)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Rozet Koleksiyonu")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(badges.filter { $0.condition(totalCompletions) }.count) / \(badges.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                          
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 15)], spacing: 15) {
                                ForEach(badges) { badge in
                                    BadgeView(badge: badge, isUnlocked: badge.condition(totalCompletions))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profil")
        }
    }
    

    var totalCompletions: Int {
        habits.reduce(0) { count, habit in
            count + (habit.completionDates?.count ?? 0)
        }
    }
    
    var bestStreak: Int {
        habits.map { Int($0.streakCount) }.max() ?? 0
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .padding(10)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct BadgeView: View {
    let badge: ProfileView.Badge
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
              
                Circle()
                    .fill(isUnlocked ? badge.color.opacity(0.15) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
               
                Image(systemName: badge.icon)
                    .font(.system(size: 26))
                    .foregroundColor(isUnlocked ? badge.color : .gray)
                    .saturation(isUnlocked ? 1 : 0)
                
               
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .padding(4)
                        .background(Circle().fill(.white))
                        .foregroundColor(.gray)
                        .offset(x: 20, y: 20)
                        .shadow(radius: 1)
                }
            }
            .padding(.top, 5)
            
            VStack(spacing: 2) {
               
                Text(badge.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
              
                Text(badge.description)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 5)
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
        .opacity(isUnlocked ? 1 : 0.6)
        .grayscale(isUnlocked ? 0 : 1)
    }
}
