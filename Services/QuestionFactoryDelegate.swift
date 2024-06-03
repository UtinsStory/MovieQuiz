//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Гена Утин on 20.05.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didRecieveNextQuestion(question: QuizQuestion?)
    
}
