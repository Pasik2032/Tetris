//
//  UserServiceAssembly.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import Swinject
import NetworkingLayer

final class UserServiceAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(UserServiceProtocol.self) { resolver in
      let networking = resolver.resolve(NetworkingProtocol.self)!
      let socket = SocketService()
      return UserService(networking: networking, socket: socket)
    }
  }
}
