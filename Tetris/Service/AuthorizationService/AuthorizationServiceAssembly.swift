//
//  AuthorizationServiceAssembly.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import Swinject
import NetworkingLayer

final class AuthorizationServiceAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(AuthorizationServiceProtocol.self) { resolver in
      let networking = resolver.resolve(NetworkingProtocol.self)!
      let socket = resolver.resolve(SocketServiceProtocol.self)!
      return AuthorizationService(networking: networking, socket: socket)
    }
  }
}
