    //
    //  ContentView.swift
    //  HabitHero
    //
    //  Created by Bruna Bianca Crespo Mello on 19/11/2024.
    //

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var habits: [Habit]
    @State private var isAddingHabit = false
        
    var body: some View {
        NavigationView {
            List {
                if habits.isEmpty {
                    Text("Empty List")
                } else {
                    ForEach(habits, id:\.self) { habit in
                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                            habitRow(for: habit)
                        }
                        
                    }
                    .onDelete(perform: deleteHabit)
                }
            }
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddingHabit = true
                    }) {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingHabit) {
                AddHabitView()
            }
        }
    }
    
        // Função para criar a linha de cada hábito
    private func habitRow(for habit: Habit) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.title)
                    .font(.headline)
                Text(habit.details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(habit.completionCount) / CGFloat(habit.targetCount))
                    .stroke(habit.completionCount >= habit.targetCount ? Color.green : Color.red, lineWidth: 8)
                    .rotationEffect(.degrees(-90))
                Text("\(habit.targetCount)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .frame(width: 60, height: 60)
        }
        .padding(.vertical, 8)
    }
    
        // Função para deletar hábitos reais
    private func deleteHabit(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let habitToDelete = habits[index]
                modelContext.delete(habitToDelete)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
