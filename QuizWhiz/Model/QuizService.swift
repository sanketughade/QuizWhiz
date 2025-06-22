//
//  QuizService.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 22/06/25.
//

import Foundation

struct QuizService {
    static func fetchQuestions(numberOfQuestions: String, category: String, difficulty: String, completion: @escaping (Result<[QuizQuestion], Error>) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=10&difficulty=\(difficulty.lowercased())&type=multiple"
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(QuizAPIResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
