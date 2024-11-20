//
//  HabitDetailView.swift
//  HabitHero
//
//  Created by Bruna Bianca Crespo Mello on 19/11/2024.
//
import SwiftUI
import SwiftData
import Charts

struct HabitDetailView: View {
    @Bindable var habit: Habit
    private let daysOfWeek: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State private var completedDays: [Bool] = Array(repeating: false, count: 42) // Para 6 semanas (42 células)
    @State private var completedDates: [Date: Bool] = [:]
    @State private var currentDate: Date = Date()
    @State private var calendarDays: [(date: Date?, weekday: String)] = [] // Dias do calendário

    
    // Inicializa o estado com base no número de dias do mês
    init(habit: Habit) {
        self.habit = habit
        self._calendarDays = State(initialValue: HabitDetailView.calculateCalendarDays(for: Date()))
    }

    
    var body: some View {
        
        VStack(spacing: 16) {
            // Título
            Text(habit.title)
                .font(.largeTitle)
                .bold()
            
            Text(habit.details)
                .font(.body)
                .foregroundColor(.gray)
            
            HStack {
                
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding(.horizontal, 10)
                }
                
                Spacer()
                
                Text(currentMonth)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .padding(.horizontal, 10)
                }
            }
            .padding(.horizontal, 10)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 7), spacing: 10) {
                    
                    //Week Days
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    
                    //Day of month circles
                    ForEach(0..<calendarDays.count, id: \.self) { index in
                        if let date = calendarDays[index].date {
                            
                            ZStack {
                                
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(
                                        completedDates[date] ?? false ? colorForIndex(dayIndex(date)) : .gray
                                    )
                                    .opacity(completedDates[date] ?? false ? 1.0 : 0.3)

                                
                                VStack {
                                    Text(dayText(date))
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        
                                }
                            }
                            .onTapGesture {
                                toggleCompletion(for: date)
                            }
                            
                        } else {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.clear)
                        }
                        
                    }
                    .padding(.vertical, 5)
                    
                }
           
        }
        .padding(.horizontal)
        
        ProgressView(
            value: Double(habit.completionCount),
            total: Double(habit.targetCount)
        )
        .progressViewStyle(LinearProgressViewStyle(tint: .gray))
        .overlay(
            LinearGradient(
                colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .mask(ProgressView(
            value: Double(habit.completionCount),
            total: Double(habit.targetCount)
        )
        .progressViewStyle(LinearProgressViewStyle(tint: .blue)))
        .padding()
        
        
        Text("Target: \(habit.completionCount) / \(habit.targetCount)")
            .font(.headline)
        
        Spacer()
        
        Text("Your Progress:")
            .font(.title3)
            .bold()
        
        Chart(dataForWeek()) { item in
            BarMark(
                x: .value("Day", item.day),
                y: .value("Completed", item.completedTasks)
            )
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorForDay(item.day),
                        colorForDay(item.day).opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .gray.opacity(0.4), radius: 5, x:2, y:2)
            .cornerRadius(5)
            
        }
        .frame(height: 200)
        .padding()
                
        
    }
    
    
    
    //Funcoes
    
    //Cores do grafico
    func colorForDay(_ day: String) -> Color {
        if let index = daysOfWeek.firstIndex(of: day) {
            return colorForIndex(index)
        }
        return .gray // Cor padrão caso o dia não seja encontrado
    }
    
    //Grafico
    func dataForWeek() -> [DayProgress] {
        let calendar = Calendar.current
        var progress: [String: Int] = daysOfWeek.reduce(into: [:]) { $0[$1] = 0 }
        
            // Conta as datas completadas para cada dia da semana
        for (date, completed) in completedDates where completed {
            let weekday = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            progress[weekday, default: 0] += 1
        }
        
            // Mapeia os dias da semana para a estrutura DayProgress
        return daysOfWeek.map { day in
            DayProgress(day: day, completedTasks: progress[day, default: 0])
        }
    }
    
    
        // Formata o mês atual
    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
        // Atualiza o mês e recalcula os dias do calendário
    private func changeMonth(by value: Int) {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) else { return }
        currentDate = newDate
        calendarDays = HabitDetailView.calculateCalendarDays(for: currentDate)
    }

    
        // Alterna o estado de conclusão para uma data
    private func toggleCompletion(for date: Date) {
        completedDates[date] = !(completedDates[date] ?? false)
        updateCompletionCount()
    }
    
        // Atualiza o progresso baseado no número de dias concluídos
    private func updateCompletionCount() {
        habit.completionCount = completedDates.values.filter { $0 }.count
    }

    
        // Calcula os dias do calendário para um determinado mês
    static func calculateCalendarDays(for date: Date) -> [(date: Date?, weekday: String)] {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        let range = calendar.range(of: .day, in: .month, for: startOfMonth) ?? (1..<32)
        
            // Ajusta os dias antes do início do mês
        let firstWeekday = calendar.component(.weekday, from: startOfMonth) - 1
        let daysBeforeStart: [(date: Date?, weekday: String)] = Array(repeating: (date: nil, weekday: ""), count: firstWeekday)
        
            // Gera os dias do mês com os dias da semana correspondentes
        let daysInMonth = range.map { day -> (date: Date, weekday: String) in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
            let weekday = Calendar.current.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            return (date: date, weekday: weekday)
        }
        
        return daysBeforeStart + daysInMonth
    }
    
        // Formata o texto para exibir o número do dia
    private func dayText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
        // Retorna o índice do dia da semana
    private func dayIndex(_ date: Date) -> Int {
        Calendar.current.component(.weekday, from: date) - 1
    }

    
        // Retorna uma cor com base no índice do dia
    private func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
        return colors[index % colors.count]
    }
}

// Estrutura para progresso do dia
struct DayProgress: Identifiable {
    let id = UUID()
    let day: String
    let completedTasks: Int
}

#Preview {
    HabitDetailView(habit: Habit(title: "Study SwiftUI", details: "Track learning progress", targetCount: 5))
}
