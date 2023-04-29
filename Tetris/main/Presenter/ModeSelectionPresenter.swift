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
  var router: ModeSelectionRouterInput?
  weak var output: ModeSelectionModuleOutput?
}

// MARK: - ModeSelectionViewOutput

extension ModeSelectionPresenter: ModeSelectionViewOutput {
  func touchButtonSingle() {

  }

  func touchButtonMulty() {

  }

  func touchButtonControll() {
    router?.showControl()
  }


  func viewDidLoad() {

  }
}

// MARK: - ModeSelectionInput

extension ModeSelectionPresenter: ModeSelectionModuleInput {

}
