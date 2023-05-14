//
//  GameService.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.05.2023.
//

import Foundation
import NetworkingLayer

protocol GameServiceProtocol {
  func start()
  var output: GameServiceOutput? { get set }
  func sendAction(action: ActionTetris)
  func finish()
}

protocol GameServiceOutput {
  func startRemoutGame()
  func setGenerate(figure: [Int])
  func action(_ action: ActionTetris)
}

final class GameService {

  enum Status {
    case waitStart
    case game
  }

  private let socket: SocketServiceProtocol
  private var status: Status = .waitStart
  var output: GameServiceOutput?

  init(socket: SocketServiceProtocol) {
    self.socket = socket
    socket.subscr(self)
  }
}

extension GameService: GameServiceProtocol {
  func finish() {
    socket.send("finish")
  }

  func start() {
    socket.send("ready")
  }

  func sendAction(action: ActionTetris) {
    socket.send(action.rawValue)
  }
}

extension GameService: SocketServiceDelegate {
  func getMessage(str: String) {
    switch status {
    case .waitStart where str == "game":
      output?.startRemoutGame()
      status = .game
    case .waitStart where str.split(separator: " ")[0] == "generation:":
      var arr = str.split(separator: " ")
      arr.removeFirst()
      output?.setGenerate(figure: arr.compactMap { Int($0) })
    case .game where ActionTetris(rawValue: str) != nil:
      let action = ActionTetris(rawValue: str)!
      output?.action(action)
    default: break
    }
  }
}
