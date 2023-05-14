//
//  GameServiceAssembly.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.05.2023.
//

import Foundation
import Swinject
import NetworkingLayer

final class GameServiceAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(GameServiceProtocol.self) { resolver in
      let socket = resolver.resolve(SocketServiceProtocol.self)!
      return GameService(socket: socket)
    }
  }
}
