//
//  OnlineServiceAssembly.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2023.
//

import Foundation
import Swinject
import NetworkingLayer

final class OnlineServiceAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(OnlineServiceProtocol.self) { resolver in
      let networking = resolver.resolve(NetworkingProtocol.self)!
      let socket = resolver.resolve(SocketServiceProtocol.self)!
      return OnlineService(networking: networking, socket: socket)
    }
  }
}
