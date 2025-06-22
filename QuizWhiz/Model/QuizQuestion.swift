//
//  QuizQuestion.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 08/06/25.
//

import Foundation

struct QuizAPIResponse: Codable {
    let response_code: Int
    let results: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}
