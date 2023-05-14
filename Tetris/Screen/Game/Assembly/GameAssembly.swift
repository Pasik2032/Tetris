//
//  GameModuleConfigurator.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 13.05.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Swinject

typealias GameModule = GameViewController

final class GameAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(GameModule.self) { (resolver, type: GamePresenter.TypeGame) in
      let gameService = resolver.resolve(GameServiceProtocol.self)!
      let presenter = GamePresenter(type: type, gameService: gameService)
      let view = GameViewController(presenter: presenter)
      presenter.view = view
      return view
    }
  }
}
