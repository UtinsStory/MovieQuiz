//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Гена Утин on 21.05.2024.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didShowAlert(controller: UIAlertController?)
}
