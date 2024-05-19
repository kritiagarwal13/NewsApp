//
//  APICaller.swift
//  NewsApp
//
//  Created by Kriti Agarwal on 19/05/24.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesUrl = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2024-04-19&sortBy=publishedAt&apiKey=***")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesUrl else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}

