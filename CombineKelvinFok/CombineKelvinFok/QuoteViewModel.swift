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
    
    //프로토콜을 이용한 의존성 주입 같다. -> 의존성을 주입해야되는 이유가 무엇일까
    init(quetoServiceType: QuoteServiceType = QuoteService()) {
        self.quetoServiceType = quetoServiceType
    }
    
    //Q: AnyPublisher???? 중요하지 않는 publisher를 구현
    // AnyPublisher : 이건 계산하기 편하게 하는 퍼블리셔이다. Operator를 사용하면서 변경 될 수 있는 퍼블리셔를 감싸서 값 변경에 대한 안정성을 높혀준다.
    func transforem(input : AnyPublisher<Input,Never>) -> AnyPublisher<Output, Never> {
        
        // 넘겨받은 input을  case에 따라서 행동할 함수로 할당할 수 있다.
        input.sink{ [weak self] event in
            switch event {
            case .viewDidApear, .tapRefreshButton:
                self?.handleGetRandomQuote()
            }
        }.store(in: &cancellable) // cancellable에 저장
        
        return output.eraseToAnyPublisher() // ViewModel의 output을 넘겨준다.
    }
    
    //MARK: URL통신부분을 Publisher를 통해 보낸다.
    /**
     Description : API통신처리
     Date : 2024 . 06 . 24
     author :  JH
     */
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
