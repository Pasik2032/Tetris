//
//  OnlineService.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2023.
//

import Foundation
import NetworkingLayer

struct UserModel: Codable {
  var id: Int
  var username: String
}

protocol OnlineServiceProtocol {
  func getOnline(
    succes: @escaping ([UserModel]) -> Void,
    failed:  @escaping (String) -> Void
  )

  func responseGame(
    name: String,
    success: @escaping () -> Void,
    cancel: @escaping () -> Void
  )

  func aproveGame(
    success: @escaping () -> Void,
    cancel: @escaping () -> Void
  )

  func cancel()
  func exit()

  var delegate: OnlineServiceDelegate? { get set }
}

protocol OnlineServiceDelegate {
  func requestGame(name: String)
}

final class OnlineService {

  enum Status {
    case request
    case wait
  }

  private let networking: NetworkingProtocol
  private let socket: SocketServiceProtocol
  private var status: Status = .wait

  var delegate: OnlineServiceDelegate?

  private var success: (() -> Void)?
  private var cancelAction: (() -> Void)?

  init(
    networking: NetworkingProtocol,
    socket: SocketServiceProtocol
  ) {
    self.networking = networking
    self.socket = socket
    socket.subscr(self)
  }
}

extension OnlineService: OnlineServiceProtocol {
  func exit() {
    socket.send("exit")
  }

  func getOnline(
    succes: @escaping ([UserModel]) -> Void,
    failed: @escaping (String) -> Void
  ) {
    networking.request(API: .user(.fetchOnline)) { (model: [UserModel]) in
      succes(model)
    } onFailure: { error in
      failed(error.message)
    }
  }

  func responseGame(
    name: String,
    success: @escaping () -> Void,
    cancel: @escaping () -> Void
  ) {
    status = .request
    socket.send("response \(name)")
    self.cancelAction = cancel
    self.success = success
  }

  func cancel() {
    status = .wait
    socket.send("cancel")
  }

  func aproveGame(
    success: @escaping () -> Void,
    cancel: @escaping () -> Void
  ) {
    status = .request
    socket.send("ok")
    self.success = success
    self.cancelAction = cancel
  }
}

extension OnlineService: SocketServiceDelegate {
  func getMessage(str: String) {
    switch status {
    case .request where str == "start":
        success?()
    case .request where str == "cancel":
        cancelAction?()
        status = .wait
    case .wait where str.split(separator: " ")[0] == "request":
      delegate?.requestGame(name: String(str.split(separator: " ")[1]))
    default: break
    }
  }
}
