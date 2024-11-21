import Foundation
import SwiftData

@Model
class Habit: ObservableObject {
    
    var completionCount: Int // Não precisa ser @Published
    var targetCount: Int { 366 } // Constante calculada
    var completedDates: [String: Bool] // Controle interno, não precisa ser @Published
    
    var title: String
    var details: String
    var icon: String
    
    init(title: String, details: String, icon: String = "⭐") {
        self.title = title
        self.details = details
        self.icon = icon
        self.completedDates = [:]
        self.completionCount = 0
        
    }
    
        // Incrementa o progresso e marca a data atual como concluída
    func incrementCompletion() {
        if completionCount < targetCount {
            completionCount += 1 // Incrementa o progresso
            addCompletion(for: Date()) // Marca a data como concluída
        }
    }
    
        // Calcula a porcentagem de progresso
    func progressPercentage() -> Double {
        guard targetCount > 0 else { return 0.0 }
        return Double(completionCount) / Double(targetCount)
    }
    
        // Reseta o hábito
    func resetHabit() {
        completionCount = 0
        completedDates.removeAll()
    }
    
        // Carrega as datas concluídas no formato [Date: Bool]
    func loadCompletedDates() -> [Date: Bool] {
        return completedDates.reduce(into: [Date: Bool]()) { result, pair in
            if let date = Self.stringToDate(pair.key) {
                result[date] = pair.value
            }
        }
    }
    
        // Adiciona ou atualiza a data
    func addCompletion(for date: Date) {
        let dateKey = Self.dateToString(date)
        completedDates[dateKey] = true
    }
    
        // Verifica se uma data está concluída
    func isDateCompleted(_ date: Date) -> Bool {
        let dateKey = Self.dateToString(date)
        return completedDates[dateKey] ?? false
    }
    
        // Remove uma data do dicionário
    func removeCompletion(for date: Date) {
        let dateKey = Self.dateToString(date)
        completedDates[dateKey] = nil
    }
    
        // Converte uma data em String
    static func dateToString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate] // Inclui apenas a data
        return formatter.string(from: date)
    }
    
        // Converte uma String em Date
    static func stringToDate(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate] // Compatível com a conversão para data
        return formatter.date(from: string)
    }
}

extension Habit {
    static var mockData: [Habit] {
        return [
            Habit(title: "Exercise", details: "Go to the gym for 30 minutes.", icon: "💪"),
            Habit(title: "Read", details: "Read 10 pages of a book.", icon: "📖"),
            Habit(title: "Meditate", details: "Meditate for 10 minutes.", icon: "🧘"),
            Habit(title: "Drink Water", details: "Drink 8 glasses of water.", icon: "💧"),
            Habit(title: "Learn SwiftUI", details: "Practice SwiftUI for 1 hour.", icon: "📱"),
            Habit(title: "Learn Swift", details: "Practice Swift for 1 hour.", icon: "📱"),
        ]
    }
}

