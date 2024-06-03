//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Гена Утин on 23.05.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double{ get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
}

