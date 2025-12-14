//
//  HabitListView.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    
    @StateObject var viewModel = HabitListViewModel()
    @State private var showingAddHabit = false
    
    // MARK: - Arama Durumu
    @State private var searchText = ""
    @State private var isSearching = false
    
    // MARK: - GÜNLÜK SÖZ İÇİN HAFIZA YÖNETİMİ
    @AppStorage("savedQuote") private var savedQuote: String = "Zinciri kırma!"
    @AppStorage("savedQuoteDate") private var savedQuoteDate: String = ""
    
    let quotes = [
        "Zinciri kırma!",
        "Bugün atacağın adım, yarınki başarındır.",
        "Bin millik yolculuk tek bir adımla başlar.",
        "Sadece başla, gerisi gelecektir.",
        "Disiplin, istediklerinle ihtiyaçların arasındaki köprüdür.",
        "Ertelemek, dünün mezarlığıdır.",
        "Başarı, her gün tekrarlanan küçük çabaların toplamıdır.",
        "Geleceği tahmin etmenin en iyi yolu onu yaratmaktır."
    ]
    
    var filteredHabits: [Habit] {
        if searchText.isEmpty {
            return viewModel.habits
        } else {
            return viewModel.habits.filter { habit in
                (habit.title ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR") // Türkçe tarih
        formatter.dateFormat = "d MMMM EEEE"
        return formatter.string(from: Date()).capitalized
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
               
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // MARK: - ÖZEL BAŞLIK ALANI
                    if !isSearching {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Bugün")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                Text(todayDateString)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                            
                            
                            if !viewModel.habits.isEmpty {
                                Menu {
                                    Picker("Sıralama", selection: $viewModel.selectedSortCriteria) {
                                        ForEach(HabitSortCriteria.allCases) { criteria in
                                            Text(criteria.rawValue).tag(criteria)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                    }
                    
                    // MARK: - LİSTE YAPISI
                    List {
                        // 1. BÖLÜM: Motivasyon Kartı
                        if !isSearching {
                            Section {
                                ZStack {
                                 
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue)
                                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "quote.opening")
                                                .font(.caption)
                                            Text("GÜNÜN SÖZÜ")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .foregroundColor(.white.opacity(0.8))
                                        
                                        Text(savedQuote)
                                            .font(.headline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding()
                                }
                                .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        }
                        
                        // 2. BÖLÜM: Alışkanlıklar
                        ForEach(filteredHabits) { habit in
                            HabitListRowView(habit: habit, viewModel: viewModel, isHabitCompletedToday: isHabitCompletedToday)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        }
                        .onDelete(perform: viewModel.deleteHabit)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton().fontWeight(.medium)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddHabit = true } label: {
                        Image(systemName: "plus")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(8)
                            .background(Circle().fill(Color.blue.opacity(0.1)))
                    }
                }
            }
            .searchable(text: $searchText, isPresented: $isSearching, prompt: "Alışkanlık ara...")
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(viewModel: viewModel)
            }
            .overlay {
                if filteredHabits.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search.padding(.top, 50)
                } else if viewModel.habits.isEmpty {
                    EmptyStateView()
                }
            }
            .onAppear { checkDailyQuote() }
            .animation(.default, value: viewModel.habits)
            .animation(.default, value: searchText)
        }
    }
    
    // MARK: - YARDIMCI FONKSİYONLAR
    private func checkDailyQuote() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        
        if savedQuoteDate != todayString {
            savedQuote = quotes.randomElement() ?? "Zinciri kırma!"
            savedQuoteDate = todayString
        }
    }
    
    private func isHabitCompletedToday(_ habit: Habit) -> Bool {
        guard let lastCompleted = habit.lastCompleted else { return false }
        return Calendar.current.isDateInToday(lastCompleted)
    }
}


struct HabitListRowView: View {
    @ObservedObject var habit: Habit
    @ObservedObject var viewModel: HabitListViewModel
    var isHabitCompletedToday: (Habit) -> Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            NavigationLink(destination: HabitDetailView(habit: habit)) { EmptyView() }.opacity(0)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(habit.theme.color.opacity(0.15)).frame(width: 50, height: 50)
                    Image(systemName: habit.theme.iconName).font(.title3).foregroundColor(habit.theme.color)
                    if habit.isPinned {
                        Image(systemName: "pin.fill").font(.system(size: 10)).padding(4).background(Circle().fill(Color.white)).foregroundColor(.orange).offset(x: 18, y: -18).shadow(radius: 2)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title ?? "").font(.headline).foregroundColor(.primary)
                    HStack(spacing: 6) {
                        Label("\(habit.streakCount)", systemImage: "flame.fill").font(.caption).fontWeight(.medium).foregroundColor(habit.streakCount > 0 ? .orange : .gray)
                        Text("•").foregroundColor(.secondary)
                        Text(habit.isNotificationEnabled ? "Bildirim Açık" : "Sessiz").font(.caption).foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { viewModel.markHabitCompleted(habit) }
                } label: {
                    Image(systemName: isHabitCompletedToday(habit) ? "checkmark.circle.fill" : "circle").resizable().frame(width: 32, height: 32).foregroundColor(isHabitCompletedToday(habit) ? .green : .gray.opacity(0.3)).background(Circle().fill(.white))
                }.buttonStyle(.plain)
            }.padding(12)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button { withAnimation { habit.isPinned.toggle(); viewModel.manager.save(); viewModel.objectWillChange.send() } } label: { Label(habit.isPinned ? "Kaldır" : "Sabitle", systemImage: habit.isPinned ? "pin.slash.fill" : "pin.fill") }.tint(habit.isPinned ? .gray : .orange)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(role: .destructive) { if let index = viewModel.habits.firstIndex(of: habit) { viewModel.deleteHabit(offsets: IndexSet(integer: index)) } } label: { Label("Sil", systemImage: "trash.fill") }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack { Circle().fill(Color.blue.opacity(0.1)).frame(width: 100, height: 100); Image(systemName: "plus").font(.system(size: 40, weight: .bold)).foregroundColor(.blue) }
            VStack(spacing: 8) { Text("Hadi Başlayalım!").font(.title2).fontWeight(.bold); Text("İlk alışkanlığını eklemek için sağ üstteki artı (+) butonuna tıkla.").font(.body).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 40) }
        }.padding(.top, -50)
    }
}
