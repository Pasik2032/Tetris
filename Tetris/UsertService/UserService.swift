//
//  UserService.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import NetworkingLayer

protocol UserServiceProtocol {
  func getOnline(
    succes: @escaping ([UserModel]) -> Void,
    failed:  @escaping (String) -> Void
  )
}

final class UserService {
  private let networking: NetworkingProtocol

  init(networking: NetworkingProtocol) {
    self.networking = networking
  }
}

extension UserService: UserServiceProtocol {
  func getOnline(succes: @escaping ([UserModel]) -> Void, failed:  @escaping (String) -> Void) {
    networking.request(API: .user(.fetchOnline)) { (model: [UserModel]) in
      succes(model)
    } onFailure: { error in
      failed(error.message)
    }
  }
}
