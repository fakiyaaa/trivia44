//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Fakiya Imangaliyeva on 3/18/24.
//
//  TriviaQuestionService.swift


import Foundation

extension String {
    func convertHTMLEntities() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                                          documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error converting HTML entities: \(error)")
            return nil
        }
    }
    
    
}

class TriviaQuestionService {
    static func fetchQuestion(amount: Int, completion: @escaping (TriviaAPIResponse) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=\(amount)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let triviaResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
                completion(triviaResponse)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

struct TriviaAPIResponse: Decodable {
    let results: [TriviaQuestion]
}
