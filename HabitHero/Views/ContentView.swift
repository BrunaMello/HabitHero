//
//  ContentView.swift
//  HabitHero
//
//  Created by Bruna Bianca Crespo Mello on 19/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var habits: [Habit] 
    @State private var isAddingHabit = false
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                ForEach(habits) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit)) {
                        VStack(alignment: .leading) {
                            Text(habit.title)
                                .font(.headline)
                            Text("\(habit.completionCount)/\(habit.targetCount) completions")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationTitle("Habit Hero")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingHabit.toggle() }) {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingHabit) {
                AddHabitView()
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            modelContext.delete(habit)
        }
    }

    
}

#Preview {
    ContentView()
}
