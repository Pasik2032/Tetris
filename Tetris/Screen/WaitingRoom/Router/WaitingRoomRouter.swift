//
//  WaitingRoomRouter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2023.
//

import Foundation
import UIKit
import Swinject

final class WaitingRoomRouter {

  private weak var view: UIViewController?
  private var alert: UIAlertController?
  private var resolver: Resolver

  init(view: UIViewController, resolver: Resolver) {
    self.view = view
    self.resolver = resolver
  }

  func showWaiting(username: String, handel: @escaping (UIAlertAction) -> Void) {
    alert = UIAlertController(
      title: "Ожидание игрока",
      message: "Игра запрошенна. \(username) должен принять запрос на игру",
      preferredStyle: .alert
    )
    alert?.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: handel))
    view?.present(alert!, animated: true, completion: nil)
  }

  func closeAlert() {
    alert?.dismiss(animated: true)
  }

  func showGame() {
    alert?.dismiss(animated: true)
    let vc = resolver.resolve(GameModule.self, argument: GamePresenter.TypeGame.multy)!
    vc.modalPresentationStyle = .overFullScreen
    view?.present(vc, animated: true)
  }
}
