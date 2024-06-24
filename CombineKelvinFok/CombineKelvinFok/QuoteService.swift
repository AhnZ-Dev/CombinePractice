//
//  QuoteService.swift
//  CombineKelvinFok
//
//  Created by Jihoon on 6/17/24.
//
import Combine
import Foundation

// QuoteServiceType을 프로토콜을
protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote,Error>
}

class QuoteService: QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        let url = URL(string: "https://api.quotable.io/random")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map{$0.data} // 필요한 data만 뽑는다.
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct Quote: Decodable{
    let content: String
    let author: String
}
