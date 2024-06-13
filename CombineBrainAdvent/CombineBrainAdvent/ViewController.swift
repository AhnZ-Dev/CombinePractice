//
//  ViewController.swift
//  CombineBrainAdvent
//
//  Created by Jihoon on 6/12/24.
//
import Combine
import UIKit

/*
 Publisher(날씨전송안테나)     ->      Time(온도 + 아이콘)   ->    Subscriber -> 라디오 + Operator(온도+아이콘에서 아이콘을 없애줘서 온도만 들어 갈 수 있게 해줌)
 ** Publisher
 1. 어떻게 값과 에러를 정의하는가
 2. 값 타입
 3. 구독의 등록을 허락한다.
 
 ** Subscriber
 1. 값, 완료여부를 수신
 2. 참조 타입
 
 ** Operator
 1. Publisher를 채택
 2. 값 변경에 대한 행동 설명
 3. 업스트림이라고 부르는 퍼블리셔를 구독
 4. 다운스트림이라는 Subscriber에 데이터 전송
 5. 값 타입 (퍼블리셔와같음)
 
 * protocol Publisher<Output, Failure> 보내는애니까 아웃풋 필요함
 
 * Subscriber<Input, Failure> 받는애니까 Input이 필요함
 sink(완료여부, 값), assign(지정장소에 넣어줌)
 
 
 
 */

enum WeatherError: Error {
    case thingsJustHappen
}

extension Notification.Name {
    static let newMessage = Notification.Name("newMessage")
}

struct Message {
    let content: String
    let author: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var allowMessagesSwitch: UISwitch! 
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // PropertyWrapper ??
    @Published var canSendMessages: Bool = false
    
    private var switchSubscriber: AnyCancellable? // 메모리관리 // 뷰가 종료될 때 구독을 확인하고 삭제
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        playgroundCombine() // playground형 연습
        setupProcessingChain()
        setupTargetActions()
        setupUI()
    }
    // UI설정
    func setupUI(){
        sendButton.setTitleColor(.systemPink, for: .disabled) // 비활성화시 동작시 버튼 텍스트 색 변경
        messageLabel.sizeToFit()
        
    }
    
    // 버튼 동작 연결 및 버튼상태 별 UI 변경
    func setupTargetActions(){
        allowMessagesSwitch.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
    }
    // Bind
    func setupProcessingChain(){
        print("setupProcessingChain")
        switchSubscriber = $canSendMessages.receive(on: DispatchQueue.main)// mainThread
            .print("enter value")
            .assign(to: \.isEnabled, on: sendButton) // Button의 isEnabled 속성에 넣어줌
        
        let messagePublisher = NotificationCenter.Publisher(center: .default, name: .newMessage) // 해당 Notification이 호출 될 때
            .map{notification -> String? in // String?형 변환(object가 옵셔널형)
                return (notification.object as? Message)?.content ?? "" // 형 변환 후 필요한 Content 요소만 가져옴
            }
        
        let messageSubscriber = Subscribers.Assign(object: messageLabel, keyPath: \.text)
        messagePublisher.subscribe(messageSubscriber) 
        
    }
    
    @objc func didSwitch(_ sender: UISwitch){
        print("didSwitch")
        canSendMessages = sender.isOn
    }
    
    @objc func sendMessage(_ sender: UIButton){
        print("sendMessage")
//        canSendMessages = sender.isEnabled
        let message = Message(content: "The current Time is \(Date())", author: "Me") // 구조체 생성
        NotificationCenter.default.post(name: .newMessage, object: message) // Notification에 구조체를 보냄
    }
}

// playground형 Combine 연습
extension ViewController {
    func playgroundCombine(){
        let weatherPublisher = PassthroughSubject<Int,Never>() // Publisher
        
        let subscriber = weatherPublisher // Subscriber
            .filter {$0 > 25} // Operator
            .sink { value in // 연결
                print("A Summer day of \(value) ")
            }
        
        // handleEvent로 Subscriber의 상태 및 호출 값을 받아 올 수 있다.
        let anothersubscriber = weatherPublisher.handleEvents (receiveSubscription: { subscription in
            print("NewSubscription \(subscription)") // 어떤 Subscriber가 구독되었는지!
        }, receiveOutput: { output in // 어떤 것이 출력되는지
            print("new Value: Output \(output)")
        }, receiveCompletion: { err in // error 수신
            print("potentialErr : \(err)")
        }, receiveCancel: {
            print("NewSubscription cancel")
        }).sink{value in
            print("Subscription : \(value)") // 들어온게 뭔지
        }
        
        weatherPublisher.send(10)
        weatherPublisher.send(20)
        weatherPublisher.send(20)
        weatherPublisher.send(30)
        weatherPublisher.send(18) // send로 쏘면 이미 구독이 되어있기 떄문에 그냥 계속 타는거야
    }
}
