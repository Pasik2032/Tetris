//
//  UserService.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import NetworkingLayer
import UIKit

protocol UserServiceProtocol {
  func getOnline(
    succes: @escaping ([UserModel]) -> Void,
    failed:  @escaping (String) -> Void
  )

  func authorizationCheck(succes: @escaping ()-> Void)
}

final class UserService {
  private let networking: NetworkingProtocol
  private let socket: SocketServiceProtocol

  private var success: (() -> Void)?
  private var failed: ((String) -> Void)?
  private var callBack: (() -> Void)?

  private let userStore: UserDefaults = UserDefaults.standard
  private var data: String?

  init(networking: NetworkingProtocol, socket: SocketServiceProtocol) {
    self.networking = networking
    self.socket = socket
  }
}

extension UserService: UserServiceProtocol {
  func authorizationCheck(succes: @escaping () -> Void) {
    let userData = userStore.string(forKey: "userPassword")
    callBack = succes
    if let userData {
      socket.subscr(self)
      socket.send(userData)
    } else {
      let output: LogInOutputModule? = self
      let vc = Assembly.resolver.resolve(LogIn.self, argument: output)!
      UIViewController.topMost()?.present(vc, animated: true)
    }
  }

  func getOnline(succes: @escaping ([UserModel]) -> Void, failed:  @escaping (String) -> Void) {
    networking.request(API: .user(.fetchOnline)) { (model: [UserModel]) in
      succes(model)
    } onFailure: { error in
      failed(error.message)
    }
  }
}

extension UserService: LogInOutputModule {
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

extension UserService: SocketServiceDelegate {
  func getMessage(str: String) {
    if str == "Соеденение установленно" {
      if let data {
        userStore.set(data, forKey: "userPassword")
      }
      success?()
      callBack?()
    } else {
      failed?(str)
    }
  }
}
