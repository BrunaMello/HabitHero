//
//  Item.swift
//  HabitHero
//
//  Created by Bruna Bianca Crespo Mello on 19/11/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
