//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Гена Утин on 20.05.2024.
//

import UIKit

struct AlertModel {
    
    let title: String
    
    let message: String
    
    let buttonText: String
    
    var completion: () -> ()
    
}
