//
//  Network.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 08.05.2022.
//

import UIKit

protocol NetworkAutoresation {
    func autoresation(str: String,  completion: @escaping (String) -> Void)
}

protocol NetworkResponse {
    func response(completion: @escaping (String) -> Void)
    func cancel()
}

protocol NetworkGame {
    func requestGame(str: String)
    func responseGame(completion: @escaping (String) -> Void)
}


protocol NetworkRequest {
    var status: Status? {get set}
    func request(str: String,  completion: @escaping (String) -> Void)
}

enum Status {
    case online
    case play
    case ready
    case reqest
}

// MARK: - NetworkWebTocken
class NetworkWebTocken: NSObject{
//        private let net = "localhost"
    private let net = "MacBook-Pro-10.local"
    //MARK: - Fields
    public static let shared: NetworkWebTocken = NetworkWebTocken()

    public var status: Status?

    var websocket: URLSessionWebSocketTask?
    private var cancelClouser: ((String) -> Void)?
    private var onlineClouser: ((String) -> Void)?
    private var playClouser: ((String) -> Void)?
    private var autoresationClouser: ((String) -> Void)?
    private let eror: (String) -> Void = {str in
        print("Не обработанно \(str) \(NetworkWebTocken.shared.status)")
    }
    //MARK: - Init
    public static func getNetworkAutoresation() -> NetworkAutoresation {
        return shared
    }

    public static func getResponseAndRequest() -> NetworkResponse & NetworkRequest {
        return shared
    }

    public static func getNetworkGame() -> NetworkGame {
        NetworkWebTocken.shared.status = .play
        return shared
    }

    private override init() {
        super.init()
        let url = URL(string: "ws://\(net):8080/websocket")!
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        websocket = session.webSocketTask(with: url)
        websocket?.resume()
        print("Соеденение с сервером установленно.")
    }

    // MARK: - receive
    func receive(){
        websocket?.receive(completionHandler: { [weak self] result in
            switch result{
            case .success(let message):
                switch message {
                case .data(let data):
                    print("data: \(data)")
                case .string(let str):
                    print("Пришла строка: \(str)")
                    self?.router(input: str)
                @unknown default:
                    print("error")
                }
            case .failure(let error):
                print(error)
            }
            self?.receive()
        })
    }

    private func router(input: String){
        switch status {
        case .online: (onlineClouser ?? eror)(input)
        case .ready, .reqest: (cancelClouser ?? eror)(input)
        case .play: (playClouser ?? eror)(input)
        case .none: (autoresationClouser ?? eror)(input)
        }
    }
}


// MARK: - URLSessionWebSocketDelegate
extension NetworkWebTocken: URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("connect")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("close")
    }
}

// MARK: - Request & Response
extension NetworkWebTocken: NetworkRequest, NetworkResponse {
    func cancel() {
        websocket?.send(.string("cancel"), completionHandler: { eror in
            if let eror = eror {
                print(eror)
            }
        })
    }

    func request(str: String, completion: @escaping (String) -> Void) {
        websocket?.send(.string(str), completionHandler: { eror in
            if let eror = eror {
                print(eror)
            }
        })
        self.cancelClouser = completion
    }

    func response(completion: @escaping (String) -> Void) {
        self.onlineClouser = completion
    }
}

//MARK: - Autoresation
extension NetworkWebTocken: NetworkAutoresation{
    func autoresation(str: String,  completion: @escaping (String) -> Void) {
        websocket?.send(.string(str), completionHandler: { eror in
            if let eror = eror {
                print(eror)
            }
        })
        autoresationClouser = completion
        receive()
    }

}

extension NetworkWebTocken: NetworkGame {
    func requestGame(str: String) {
        websocket?.send(.string(str), completionHandler: { eror in
            if let eror = eror {
                print(eror)
            }
        })
    }

    func responseGame(completion: @escaping (String) -> Void) {
        self.playClouser = completion
    }


}
