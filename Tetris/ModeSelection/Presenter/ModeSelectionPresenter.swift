//
//  ModeSelectionPresenter.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 29.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ModeSelectionModuleInput: AnyObject {

}

protocol ModeSelectionModuleOutput: AnyObject {

}

final class ModeSelectionPresenter {

  // MARK: - Properties

  weak var view: ModeSelectionViewInput?
  var router: ModeSelectionRouter?
  weak var output: ModeSelectionModuleOutput?

  private var userService: UserServiceProtocol

  init(router: ModeSelectionRouter, userService: UserServiceProtocol) {
    self.router = router
    self.userService = userService
  }
}

// MARK: - ModeSelectionViewOutput

extension ModeSelectionPresenter: ModeSelectionViewOutput {
  func touchButtonSingle() {
    self.router?.showSingleGame()
  }

  func touchButtonMulty() {
    userService.authorizationCheck { [weak self] in
      self.router?.showMultyGame()
    }
  }

  func touchButtonControll() {
    router?.showControl()
  }

  func viewDidLoad() {
    userService.getOnline { model in
      print(model)
    } failed: { error in
      print(error)
    }
  }
}

// MARK: - ModeSelectionInput

extension ModeSelectionPresenter: ModeSelectionModuleInput {

}
