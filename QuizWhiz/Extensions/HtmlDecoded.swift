//
//  HtmlDecoded.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 22/06/25.
//

import Foundation

extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }

        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        }

        return self
    }
}



