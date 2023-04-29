//
//  ModeSelectionModuleConfigurator.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 29.04.2023.
//  Copyright © 2023 ISS. All rights reserved.
//

import UIKit
import Swinject

typealias ModeSelection = ModeSelectionViewController

final class ModeSelectionAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(ModeSelection.self) { resolver in
      let presenter = resolver.resolve(ModeSelectionPresenter.self)!
      return ModeSelectionViewController(presenter: presenter)
    }

    container.register(ModeSelectionRouter.self) { resolver in
      return ModeSelectionRouter()
    }

    container.register(ModeSelectionPresenter.self) { resolver in
      let router = resolver.resolve(ModeSelectionRouter.self)!
      let userService = resolver.resolve(UserServiceProtocol.self)!
      return ModeSelectionPresenter(router: router, userService: userService)
    }.initCompleted { resolver, presenter in
      let view = resolver.resolve(ModeSelection.self)!
      presenter.view = view
      presenter.router?.view = view
    }
  }
}
