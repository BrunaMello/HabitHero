//
//  AddHabitView.swift
//  HabitHero
//
//  Created by Bruna Bianca Crespo Mello on 19/11/2024.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title = ""
    @State private var details = ""
    @State private var targetCount = 1
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Details", text: $details)
                Stepper("Target: \(targetCount)", value: $targetCount, in: 1...100)
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                }
            }
        }
    }
    
    private func saveHabit() {
        let newHabit = Habit(title: title, details: details, targetCount: targetCount)
        context.insert(newHabit)
        dismiss()
    }
}

#Preview {
    AddHabitView()
}


