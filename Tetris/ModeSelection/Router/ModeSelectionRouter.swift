//
//  ModeSelectionRouter.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 29.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
import UIKit

protocol ModeSelectionRouterInput {
  func showControl()
}

final class ModeSelectionRouter {

  // MARK: - Properties

  weak var view: UIViewController?
}

// MARK: - ModeSelectionRouterInput

extension ModeSelectionRouter: ModeSelectionRouterInput {
  func showControl() {
    view?.present(ControlViewController(), animated: true)
  }

  func showMultyGame() {
    let vc = MyltyPlayerViewController()
    view?.present(vc, animated: true)
  }

  func showSingleGame() {
    let vc = ARViewController()
    view?.present(vc, animated: true)
  }
}

