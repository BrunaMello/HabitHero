//
//  HabitHeroApp.swift
//  HabitHero
//
//  Created by Bruna Bianca Crespo Mello on 19/11/2024.
//

import SwiftUI
import SwiftData

@main
struct HabitHeroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Habit.self]) // Configuração correta para o ModelContainer
    }
}
