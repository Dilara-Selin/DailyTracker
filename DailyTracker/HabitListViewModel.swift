//
//  HabitListViewModel.swift
//  DailyTracker
//
//  Created by Dilara Selin SALCI on 9.12.2025.
//


import Foundation
import CoreData

// MARK: - SIRALAMA KRİTERİ
enum HabitSortCriteria: String, CaseIterable, Identifiable {
    case creationDate = "Oluşturma Tarihi"
    case streak = "Streak (Seri)"
    
    var id: String { self.rawValue }
}

class HabitListViewModel: ObservableObject {
    

    @Published var selectedSortCriteria: HabitSortCriteria = .streak
    
  
    private var allHabits: [Habit] = []
    

    let manager = CoreDataManager.shared
    
    init() {
        fetchHabits()
    }
    
    // MARK: - HESAPLANMIŞ SIRALANMIŞ LİSTE
  
    var habits: [Habit] {
        
      
        let pinnedHabits = allHabits.filter { $0.isPinned }
        let unpinnedHabits = allHabits.filter { !$0.isPinned }
        
        
        let sortedUnpinnedHabits: [Habit]
        
        switch selectedSortCriteria {
        case .streak:
           
            sortedUnpinnedHabits = unpinnedHabits.sorted { $0.streakCount > $1.streakCount }
        case .creationDate:
          
            sortedUnpinnedHabits = unpinnedHabits.sorted { $0.dateCreated! > $1.dateCreated! }
        }
        
      
        let sortedPinnedHabits = pinnedHabits.sorted { $0.dateCreated! > $1.dateCreated! }
        
        
        return sortedPinnedHabits + sortedUnpinnedHabits
    }
    
    
    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        
        do {
            allHabits = try manager.context.fetch(request)
       
            self.objectWillChange.send()
        } catch {
            print("Alışkanlıklar çekilemedi: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD
    
    func addHabit(title: String) {
        manager.addHabit(title: title)
       
        fetchHabits()
    }
    

    func deleteHabit(offsets: IndexSet) {
      
        let habitsToDelete = offsets.map { self.habits[$0] }

       
        var indicesToDelete: IndexSet = IndexSet()
        for habit in habitsToDelete {
           
            if let index = allHabits.firstIndex(of: habit) {
                indicesToDelete.insert(index)
            }
        }
        
   
        manager.deleteHabit(offsets: indicesToDelete, habits: allHabits)
        
      
        fetchHabits()
    }
    
    // MARK: - Streak Mantığı
    func markHabitCompleted(_ habit: Habit) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastCompleted = habit.lastCompleted, Calendar.current.isDateInToday(lastCompleted) {
            print("Alışkanlık bugün zaten tamamlanmış. Streak artırılmadı.")
            return
        }
        
        var shouldIncrement = false
        var streakCount = habit.streakCount
        
        if let lastCompleted = habit.lastCompleted {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            
            if Calendar.current.isDate(lastCompleted, inSameDayAs: yesterday) {
                shouldIncrement = true
            } else {
                streakCount = 1
            }
        } else {
            shouldIncrement = true
        }
        
        if shouldIncrement {
            streakCount += 1
        }
        
        
        habit.streakCount = streakCount
        
       
        var dates = habit.completionDates ?? []
        if !dates.contains(where: { Calendar.current.isDate($0, inSameDayAs: today) }) {
            dates.append(today)
        }
        habit.completionDates = dates
        
        habit.lastCompleted = Date()
        manager.save()
        
     
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}



extension Calendar {
    func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
        return self.compare(date1, to: date2, toGranularity: .day) == .orderedSame
    }
}
