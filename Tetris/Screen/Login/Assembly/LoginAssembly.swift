//
//  LoginAssembly.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import Swinject

typealias LogIn = LoginViewController

final class LogInAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(LogIn.self) { (resolver, output: LogInOutputModule?) in
      let presenter = resolver.resolve(LoginPresenter.self, argument: output)!
      return LoginViewController(presenter: presenter)
    }

    container.register(LoginPresenter.self) { (resolver, output: LogInOutputModule?) in
      return LoginPresenter(output: output)
    }.initCompleted { resolver, presenter in
      let view = resolver.resolve(LogIn.self, argument: presenter.output)!
      presenter.view = view
    }
  }
}
