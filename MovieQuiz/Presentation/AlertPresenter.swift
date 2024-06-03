//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Гена Утин on 21.05.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: { _ in model.completion() })
        alert.addAction(action)
        delegate?.didShowAlert(controller: alert)
    }
}
