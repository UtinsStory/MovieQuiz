//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Гена Утин on 27.05.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
                userDefaults.double(forKey: Keys.total.rawValue)
            }
            set {
                userDefaults.set(newValue, forKey: Keys.total.rawValue)
            }
        }
    
    var correct: Int {
        get {
                userDefaults.integer(forKey: Keys.correct.rawValue)
            }
            set {
                userDefaults.set(newValue, forKey: Keys.correct.rawValue)
            }
        }
    
    
    var gamesCount: Int {
        get {
                userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
            set {
                userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
            
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        self.correct += count
        totalAccuracy = Double(correct) / (Double(gamesCount) * Double(amount)) * 100;
        let previous = self.bestGame
        let new = GameRecord(correct: count, total: amount, date: Date())
        if new.isBetterThan(previous) {
            self.bestGame = new
                }
    }
    
}
