//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Гена Утин on 23.05.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan (_ another: GameRecord) -> Bool {
        correct > another.correct
    }
    
}
