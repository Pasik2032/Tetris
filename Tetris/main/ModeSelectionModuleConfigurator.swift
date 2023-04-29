//
//  ModeSelectionModuleConfigurator.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 29.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ModeSelectionModuleConfigurator {

  // MARK: - Configure

  func configure(
    output: ModeSelectionModuleOutput? = nil
  ) -> (
    view: ModeSelectionViewController,
    input: ModeSelectionModuleInput
  ) {
    let view = ModeSelectionViewController()
    let presenter = ModeSelectionPresenter()
    let router = ModeSelectionRouter()

    presenter.view = view
    presenter.router = router
    presenter.output = output

    router.view = view

    view.output = presenter

    return (view, presenter)
  }
}

