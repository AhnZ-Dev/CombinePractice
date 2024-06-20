//
//  ViewController.swift
//  CombineKelvinFok
//
//  Created by Jihoon on 6/16/24.
//
import Combine
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private let vm = QuoteViewModel()
    private let input: PassthroughSubject<QuoteViewModel.Input,Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidApear)
    }
    
    private func bind(){
        let output = vm.transforem(input: input.eraseToAnyPublisher()) // 인풋을 아웃에 넣어줌 (enum형식으로 각 타입별로 들어왔을 때 output처리)
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .fetchQuoteDidSuccess(let quote):
                self?.codeLabel.text = quote.content
            case .fetchQuoteDidFail(let error):
                self?.codeLabel.text = error.localizedDescription
            case .toggleButton(let isEnable):
                self?.refreshButton.isEnabled = isEnable
            }
        }.store(in: &cancellable)

    }

    @IBAction func tapRefreshButton(_ sender: UIButton) {
        input.send(.tapRefreshButton)
    }
    
}

