import SwiftData

public struct MockModelContainer {
    
    @MainActor
    public static func create() -> ModelContext {
        do {
            let container = try ModelContainer(for: Habit.self) // Tenta criar o container
            let context = container.mainContext
            
                // Adicione dados fictícios
            let mockHabits = Habit.mockData
            for habit in mockHabits {
                do {
                    try context.insert(habit)
                } catch {
                    print("Failed to insert mock habit: \(error.localizedDescription)")
                }
            }
            
            return context
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }
}
