    //
    //  CompletionChartView.swift
    //  HabitHero
    //
    //  Created by Bruna Bianca Crespo Mello on 19/11/2024.
    //

import SwiftUI
import Charts

struct CompletionChartView: View {
    var habits: [Habit] // Lista de hábitos para o gráfico
    
    var body: some View {
        Chart(habits.sorted(by: { $0.completionCount > $1.completionCount })) { habit in
            BarMark(
                x: .value("Habit", habit.title),
                y: .value("Completions", habit.completionCount)
            )
            .foregroundStyle(by: .value("Habit", habit.title))
            .annotation(position: .overlay) {
                Text("\(habit.completionCount)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .shadow(color: .gray.opacity(0.4), radius: 5, x:2, y:2)

            
        }
        .chartYAxis {
            AxisMarks(position: .automatic, values: .stride(by: 10)) // Define intervalos
        }
        .chartYScale(domain: 0...(habits.map { $0.completionCount }.max() ?? 1)) // Garante que o eixo Y comece em 0        .chartLegend(.hidden) // Remove a legenda para manter o layout limpo
        .padding() // Adiciona margens ao redor do gráfico
        .background(Color.gray.opacity(0.1)) // Fundo com bordas arredondadas
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
    }
}
