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
    @ObservedObject var habit: Habit // Tipo não opcional
    var isEditing: Bool { !habit.title.isEmpty }
    
    @Environment(\.modelContext) private var context
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var icon: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                    .focused($isTextFieldFocused)
                    .keyboardType(.default)
                    .onSubmit {
                        isTextFieldFocused = false
                    }
                
                TextField("Details", text: $details)
                    .focused($isTextFieldFocused)
                    .keyboardType(.default)
                    .onSubmit {
                        isTextFieldFocused = false
                    }
                
                TextField("Emoji", text: $icon)
                    .focused($isTextFieldFocused)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .frame(height: 80)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.default)
                    .onChange(of: icon) {
                        validateEmojiInput(icon)
                    }
            }
            .navigationTitle(isEditing ? "Edit Habit" : "New Habit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Save" : "Add") {
                        saveHabit()
                    }
                }
            }
            .onAppear {
                title = habit.title
                details = habit.details
                icon = habit.icon
            }
        }
    }
    
    private func validateEmojiInput(_ newValue: String) {
            // Restrict input to a single emoji
        if !newValue.containsOnlyEmoji || newValue.count > 1 {
            icon = String(newValue.last ?? " ")
        }
    }
    
    private func saveHabit() {
        if isEditing {
                // Atualiza o hábito existente
            habit.title = title
            habit.details = details
            habit.icon = icon
        } else {
                // Cria um novo hábito
            let newHabit = Habit(title: title, details: details, icon: icon)
            context.insert(newHabit) // Insere no contexto do modelo
        }
        
        do {
            try context.save() // Salva as alterações
            print("Habit Saved")
            dismiss()
        } catch {
            print("Failed to save habit: \(error.localizedDescription)")
        }
    }
}

extension String {
    var containsOnlyEmoji: Bool {
        return unicodeScalars.allSatisfy { scalar in
            scalar.properties.isEmoji && (scalar.value > 0x238C || scalar.value == 0x20E3)
        }
    }
}

#Preview {
    AddHabitView(habit: Habit(title: "", details: "", icon: "⭐"))
}
