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
    @State private var habitToEdit: Habit?
    
    //Delete
    @State private var habitToDelete: Habit? // Estado para rastrear o hábito a ser deletado
    @State private var showDeleteConfirmation = false // Estado para mostrar o alerta de confirmação

    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(habits, id: \.self) { habit in
                        habitCard(for: habit)
                    }
                }
                .padding()
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
                AddHabitView(habit: Habit(title: "", details: "", icon: ""))
            }
            .sheet(item: $habitToEdit) { habit in
                AddHabitView(habit: habit)
            }
            .alert(
                "Delete Habit",
                isPresented: $showDeleteConfirmation,
                presenting: habitToDelete
            ) { habit in
                Button("Delete", role: .destructive) {
                    deleteHabit(habit)
                }
                Button("Cancel", role: .cancel) {}
            } message: { habit in
                Text("Are you sure you want to delete the habit \"\(habit.title)\"?")
            }
        }
    }
    
        // Função para criar o card de cada hábito
    private func habitCard(for habit: Habit) -> some View {
        NavigationLink(destination: HabitDetailView(habit: habit)) {
            VStack {
                Text(habit.icon)
                    .font(.largeTitle)
                
                Text(habit.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(habit.details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                        // Botão de edição
                    Button(action: {
                        habitToEdit = habit
                    }) {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .frame(width: 40, height: 40)
                    
                    Spacer()
                    
                        // Botão de exclusão
                    Button(action: {
                        habitToDelete = habit
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .padding(5)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .frame(width: 40, height: 40)
                }
                .padding(.top, 8)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
        }
    }
    
        // Função para deletar hábitos
    private func deleteHabit(_ habit: Habit) {
        withAnimation {
            modelContext.delete(habit)
        }
    }
}

#Preview {
    ContentView()
}
