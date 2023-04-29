//
//  ModeSelectionRouter.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 29.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
import UIKit
import Swinject

protocol ModeSelectionRouterInput {
  func showControl()
  func showWaitingRoom(name: String)
}

final class ModeSelectionRouter {

  // MARK: - Properties

  weak var view: UIViewController?
  var resolver: Resolver

  init(resolver: Resolver) {
    self.resolver = resolver
  }
}

// MARK: - ModeSelectionRouterInput

extension ModeSelectionRouter: ModeSelectionRouterInput {
  func showControl() {
    view?.present(ControlViewController(), animated: true)
  }

  func showSingleGame() {
    let vc = ARViewController()
    view?.present(vc, animated: true)
  }

  func showWaitingRoom(name: String) {
    let vc = resolver.resolve(WaitingRoom.self)!
    view?.navigationController?.pushViewController(vc, animated: true)
  }
}

