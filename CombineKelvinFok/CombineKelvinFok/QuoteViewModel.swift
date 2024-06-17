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
    
    init(quetoServiceType: QuoteServiceType = QuoteService()) {
        self.quetoServiceType = quetoServiceType
    }
    
    func transforem(inpit : AnyPublisher<Input,Never) -> AnyPublisher<Output, Never> {
        
    }
    
    
}
