//
//  QuoteService.swift
//  CombineKelvinFok
//
//  Created by Jihoon on 6/17/24.
//
import Combine
import Foundation

protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote,Error>
}

class QuoteService: QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        let url = URL(string: "https://api.quotable.io/random")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map{$0.data}
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct Quote: Decodable{
    let content: String
    let author: String
}
