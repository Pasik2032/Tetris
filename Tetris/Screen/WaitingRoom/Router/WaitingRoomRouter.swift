//
//  WaitingRoomRouter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2023.
//

import Foundation
import UIKit

final class WaitingRoomRouter {

  private weak var view: UIViewController?
  private var alert: UIAlertController?

  init(view: UIViewController) {
    self.view = view
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

  }
}
