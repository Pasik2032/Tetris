//
//  ModeSelectionViewController.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 29.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol ModeSelectionViewInput: AnyObject {

}

protocol ModeSelectionViewOutput: AnyObject {
  func viewDidLoad()
  func touchButtonSingle()
  func touchButtonMulty()
  func touchButtonControll()
}


final class ModeSelectionViewController: UIViewController {

  // MARK: - UI

  private lazy var buttonSingel: UIButton = {
    let control = UIButton()
    control.translatesAutoresizingMaskIntoConstraints = false
    control.setTitle("Single player", for: .normal)
    control.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
    control.setTitleColor( .white, for: .normal)
    control.addTarget(self, action: #selector(touchButtonSingle), for: .touchUpInside)
    return control
  }()

  private lazy var buttonMulty: UIButton = {
    let control = UIButton()
    control.translatesAutoresizingMaskIntoConstraints = false
    control.setTitle("Multiplayer", for: .normal)
    control.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
    control.setTitleColor( .white, for: .normal)
    control.addTarget(self, action: #selector(touchButtonMulty), for: .touchUpInside)
    return control
  }()

  private lazy var buttonControll: UIButton = {
    let control = UIButton()
    control.translatesAutoresizingMaskIntoConstraints = false
    control.setTitle("control", for: .normal)
    control.setTitleColor(.systemGray, for: .normal)
    control.addTarget(self, action: #selector(touchButtonControll), for: .touchUpInside)
    return control
  }()

  private lazy var label: UILabel = {
    let control = UILabel()
    control.translatesAutoresizingMaskIntoConstraints = false
    control.text = "TETRIS AR"
    control.font = UIFont(name: "HelveticaNeue-Bold", size: 60)
    control.textAlignment = .center
    control.textColor = .systemBlue
    return control
  }()

  // MARK: - Properties

  var output: ModeSelectionViewOutput?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    setupUI()
  }

  // MARK: - Actions

  @objc func touchButtonSingle() {
    output?.touchButtonSingle()
  }

  @objc func touchButtonMulty() {
    output?.touchButtonMulty()
  }

  @objc func touchButtonControll() {
    output?.touchButtonControll()
  }

  // MARK: - Setup

  private func setupUI() {
    view.addSubviews([
      label,
      buttonSingel,
      buttonMulty,
      buttonControll,
    ])
    makeConstraints()
  }

  private func makeConstraints() {
    label.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.centerX.equalToSuperview()
    }

    buttonSingel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-100)
    }

    buttonMulty.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(100)
    }

    buttonControll.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(300)
    }
  }
}

// MARK: - TroikaServiceViewInput

extension ModeSelectionViewController: ModeSelectionViewInput {

}
