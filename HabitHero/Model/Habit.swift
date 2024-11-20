import Foundation
import SwiftData

@Model
class Habit {
    var title: String
    var details: String
    var completionCount: Int
    var targetCount: Int
    var completedDates: [String: Bool] // Persistência em formato String para compatibilidade
    
    init(title: String, details: String, targetCount: Int) {
        self.title = title
        self.details = details
        self.completionCount = 0
        self.targetCount = max(targetCount, 1)
        self.completedDates = [:]
    }
    
        // Incrementa o progresso e marca a data atual como concluída
    func incrementCompletion() {
        completionCount += 1 // Incrementa o progresso
        if completionCount > targetCount {
            targetCount = completionCount // Atualiza o target dinamicamente
        }
        addCompletion(for: Date()) // Marca a data como concluída
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
