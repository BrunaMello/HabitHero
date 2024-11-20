//
//  Item.swift
//  HabitHero
//
//  Created by Bruna Bianca Crespo Mello on 19/11/2024.
//

import Foundation
import SwiftData

@Model
class Habit {
    var id: UUID
    var title: String
    var details: String
    var completionCount: Int
    var targetCount: Int
    var completedDates: [Date?]
    
    init(title: String, details: String, targetCount: Int) {
        self.id = UUID()
        self.title = title
        self.details = details
        self.completionCount = 0
        self.targetCount = targetCount
        self.completedDates = Array(repeating: nil, count: targetCount)
    }
    
    func incrementCompletion() {
        if completionCount < targetCount {
            completionCount += 1
        }
    }
    
    
}
