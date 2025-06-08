//
//  QuizViewController.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 08/06/25.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    var quizDetails: QuizDetails? {
        didSet {
            // Make an API call here to get the questions
            getQuestions()
        }
    }
    
    func getQuestions() {
        
    }
}
