//
//  LoginPresenter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import Foundation

protocol LogInOutputModule: AnyObject {
  func update(
    login: String,
    password: String,
    success: @escaping ()->Void,
    failed: @escaping (String)->Void
  )
}

protocol LoginPresenterProtocol: AnyObject {
  func login(login: String, password: String)
}

final class LoginPresenter: LoginPresenterProtocol {
  weak var view: LoginViewInputProtocol?
  weak var output: LogInOutputModule?

  init(output: LogInOutputModule?) {
    self.output = output
  }

  func login(login: String, password: String) {
    output?.update(
      login: login,
      password: password
    ) { [weak self] in
      guard let self else { return }
      self.view?.close()
    } failed: { [weak self] errorMessage in
      guard let self else { return }
      self.view?.showInvalid(errorMessage)
    }
  }
}
