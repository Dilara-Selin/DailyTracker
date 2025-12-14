//
//  OnboardingView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//
// OnboardingView.swift

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    var body: some View {
        TabView {
           
            OnboardingPage(
                imageName: "list.bullet.clipboard",
                title: "Alışkanlıklarını Takip Et",
                description: "Günlük hedeflerini belirle ve ilerlemeni kaydetmeye başla."
            )
            
           
            OnboardingPage(
                imageName: "chart.bar.xaxis",
                title: "İstatistiklerini Gör",
                description: "Detaylı grafiklerle haftalık performansını analiz et."
            )
            
           
            VStack {
                OnboardingPage(
                    imageName: "bell.badge.fill",
                    title: "Hatırlatıcılar Kur",
                    description: "Bildirimlerle zinciri kırma, hedeflerine ulaş."
                )
                
             
                Button {
                    withAnimation {
                        
                        isOnboarding = false
                    }
                } label: {
                    Text("Hemen Başla")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}


struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}
