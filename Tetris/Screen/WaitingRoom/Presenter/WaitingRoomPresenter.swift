//
//  WaitingRoomPresenter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import UIKit

protocol WaitingRoomPresenterProtocol {
  var users: [UserModel] { get set }
  func touchUser(index: Int)
  func touchButton()
  func cancelReqens()
  func reloadButton()
  func viewDidLoad()
  func exit()
}

final class WaitingRoomPresenter: WaitingRoomPresenterProtocol {

  var router: WaitingRoomRouter?
  public weak var view: WaitingRoomViewProtocol?

  public var users: [UserModel] = []
  private var onlineService: OnlineServiceProtocol

  init(onlineService: OnlineServiceProtocol) {
    self.onlineService = onlineService
    self.onlineService.delegate = self
  }

  func viewDidLoad() {
    fetchOnline()
  }

  private func fetchOnline() {
    onlineService.getOnline { [weak self] models in
      guard let self = self else { return }
      self.users = models
      if self.users.isEmpty {
        self.view?.showNotOnline()
      } else {
        self.view?.update()
      }
    } failed: { error in
      print("ERROR: \(error)")
    }
  }

  func reloadButton() {
    fetchOnline()
  }

  func touchUser(index: Int) {

    onlineService.responseGame(name: users[index].username) {[weak self] in
      self?.router?.showGame()
    } cancel: { [weak self] in
      guard let self else { return }
      self.router?.closeAlert()
    }

    router?.showWaiting(username: users[index].username) { [weak self] action in
      guard let self else { return }
      self.onlineService.cancel()
    }
  }

  func cancelReqens() {
    onlineService.cancel()
  }

  func touchButton() {
    onlineService.aproveGame { [weak self] in
      self?.router?.showGame()
    } cancel: {
      print("Error")
    }
  }

  func exit() {
    onlineService.exit()
  }
}

extension WaitingRoomPresenter: OnlineServiceDelegate {
  func requestGame(name: String) {
    self.view?.showResponse(name: name)
  }
}
