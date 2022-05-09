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

protocol NetworkRequest {
    func request(str: String,  completion: @escaping (String) -> Void)
}
protocol NetworkOnline {
    func getOnline(completion: @escaping (Result<[UserModel]?, Error>) -> Void)
}

class NetworkWebTocken: NSObject, NetworkAutoresation, NetworkOnline {

//    private let net = "localhost"
        private let net = "MacBook-Pro-10.local"



    var websocket: URLSessionWebSocketTask?

    private static let shared: NetworkWebTocken = NetworkWebTocken()

    private override init(){
        super.init()
        let url = URL(string: "ws://\(net):8080/websocket")!
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )

        websocket = session.webSocketTask(with: url)

        websocket?.resume()
        print("go")

    }

    private var clouser: ((String) -> Void)?

    func autoresation(str: String,  completion: @escaping (String) -> Void) {
        websocket?.send(.string(str), completionHandler: { eror in
            if let eror = eror {
                print(eror)
            }
        })
        clouser = completion
        receive()
    }

    private let eror: (String) -> Void = {str in
        print("Не обработанно \(str)")
    }

    func receive(){
        websocket?.receive(completionHandler: { [weak self] result in
            switch result{
            case .success(let message):
                switch message {
                case .data(let data):
                    print("data: \(data)")
                case .string(let str):
                    print(str)
                    (self?.clouser ?? self?.eror)!(str)
                }
            case .failure(let error):
                print(error)
            }
            self?.receive()
        })
    }

    public static func getNetworkAutoresation() -> NetworkAutoresation {
        return shared
    }

    public static func getNetworkOnline() -> NetworkOnline {
        return shared
    }

    public static func getResponseAndRequest() -> NetworkResponse & NetworkRequest {
        return shared
    }



    func getOnline(completion: @escaping (Result<[UserModel]?, Error>) -> Void){
        // get url.
        let urlString = "http://\(net):8080/user/online"
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode([UserModel].self, from: data!)
                completion(.success(obj))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
}

extension NetworkWebTocken: URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("connect")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("close")
    }
}

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
        self.clouser = completion
    }

    func response(completion: @escaping (String) -> Void) {
        self.clouser = completion
    }


}
