//
//  UserService.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import NetworkingLayer
import UIKit

protocol AuthorizationServiceProtocol {
  func authorization(success: @escaping ()-> Void)
  var name: String? { get }
}

final class AuthorizationService {
  private let networking: NetworkingProtocol
  private let socket: SocketServiceProtocol

  private var success: (() -> Void)?
  private var failed: ((String) -> Void)?
  private var callBack: (() -> Void)?

  private let userStore: UserDefaults = UserDefaults.standard
  private var data: String?
  var name: String?

  private var isAuthorization = false

  init(networking: NetworkingProtocol, socket: SocketServiceProtocol) {
    self.networking = networking
    self.socket = socket
  }
}

extension AuthorizationService: AuthorizationServiceProtocol {
  func authorization(success: @escaping () -> Void) {
    if isAuthorization { success() }
    let userData = userStore.string(forKey: "userPassword")
    callBack = success
    if let userData {
      socket.subscr(self)
      socket.send(userData)
    } else {
      let output: LogInOutputModule? = self
      let vc = Assembly.resolver.resolve(LogIn.self, argument: output)!
      UIViewController.topMost()?.present(vc, animated: true)
    }
  }
}

extension AuthorizationService: LogInOutputModule {
  func update(
    login: String,
    password: String,
    success: @escaping () -> Void,
    failed: @escaping (String) -> Void
  ) {
    self.success = success
    self.failed = failed
    socket.subscr(self)
    socket.send("\(login) \(password)")
    data = "\(login) \(password)"
    socket.receiveStart()
  }
}

extension AuthorizationService: SocketServiceDelegate {
  func getMessage(str: String) {
    if str == "Соеденение установленно" {
      name = String(data?.split(separator: " ")[0] ?? "")
      if let data {
        userStore.set(data, forKey: "userPassword")
      }
      isAuthorization = true
      success?()
      callBack?()
    } else {
      failed?(str)
    }
  }
}
