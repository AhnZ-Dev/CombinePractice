//
//  QuoteViewModel.swift
//  CombineKelvinFok
//
//  Created by Jihoon on 6/17/24.
//

import Combine
import Foundation

class QuoteViewModel {
    
    enum Input {
        case viewDidApear
        case tapRefreshButton
    }
    
    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSuccess(quote: Quote)
        case toggleButton(isEnable: Bool)
    }
    // Dependency Injection
    private let quetoServiceType: QuoteServiceType
    private let output: PassthroughSubject<Output,Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    // CurrentValue와 Passthrough의 차이점은 초기값(기존값)을 가지고 있냐의 차이다
//    private let output2: CurrentValueSubject<Output,Never> = .init(.toggleButton(isEnable: true))
    
    init(quetoServiceType: QuoteServiceType = QuoteService()) {
        self.quetoServiceType = quetoServiceType
    }
    
    //Q: AnyPublisher???? 중요하지 않는 publisher를 구현
    func transforem(input : AnyPublisher<Input,Never>) -> AnyPublisher<Output, Never> {
        input.sink{ [weak self] event in
            switch event {
            case .viewDidApear, .tapRefreshButton:
                self?.handleGetRandomQuote()
            }
        }.store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
    private func handleGetRandomQuote() {
        quetoServiceType.getRandomQuote().sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.fetchQuoteDidFail(error: error))
            }
        } receiveValue: { [weak self] quote in
            self?.output.send(.fetchQuoteDidSuccess(quote: quote))
        }.store(in: &cancellable)

        
    }
    
    
}
