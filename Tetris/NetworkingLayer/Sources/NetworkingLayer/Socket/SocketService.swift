//
//  File.swift
//  
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import Starscream

public protocol SocketServiceProtocol {
  func send(_ string: String)
  func subscr(_ delegate: SocketServiceDelegate)
  func receiveStart()
}

public protocol SocketServiceDelegate {
  func getMessage(str: String)
}

public class SocketService: NSObject {
  private var websocket: WebSocket!

  private var delegate: SocketServiceDelegate?

  public override init() {
    super.init()
    let url = URL(string: NetworkConfig.socketURL)!
    var request = URLRequest(url: URL(string: "http://MacBook-Pro-10.local:8080/websocket")!)
    request.timeoutInterval = 5
    websocket = WebSocket(request: request)
    websocket.delegate = self
    websocket.connect()
    print("\(url)")
    print("Соеденение с сервером установленно.")
  }

//  public func receive() {
//    websocket.receive { [weak self] result in
//      guard let self else { return }
//      switch result {
//      case .success(let message):
//        switch message {
//        case .data(let data):
//          print("data: \(data)")
//        case .string(let str):
//          print("Пришла строка: \(str)")
//          if str == "one-time message from server" { break }
//          self.delegate?.getMessage(str: str)
//        @unknown default:
//          print("error")
//        }
//      case .failure(let error):
//        print(error)
//      }
//      self.receive()
//    }
//  }
}

extension SocketService: SocketServiceProtocol {
  public func send(_ string: String) {
    websocket.write(string: string)
  }

  public func subscr(_ delegate: SocketServiceDelegate) {
    self.delegate = delegate
  }

  public func receiveStart() {
//    receive()
  }
}

  extension SocketService: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
      switch event {
      case .connected(let headers):

        print("websocket is connected: \(headers)")
      case .disconnected(let reason, let code):

        print("websocket is disconnected: \(reason) with code: \(code)")
      case .text(let string):
        print("Received text: \(string)")
        delegate?.getMessage(str: string)
      case .binary(let data):
        print("Received data: \(data.count)")
      case .ping(_):
        break
      case .pong(_):
        break
      case .viabilityChanged(_):
        break
      case .reconnectSuggested(_):
        break
      case .cancelled:
        print("cancelled")
      case .error(let error):
        print(error)
      }
    }


}
