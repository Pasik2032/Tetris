//
//  ControlViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 15.05.2022.
//

import UIKit

final class ControlViewController: UIViewController {

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
    label.textColor = .black
    label.text = "Control"
    return label
  }()

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .black
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = """
swipe left - the figure moves to the left
swipe right - the figure moves to the right
swipe down - the figure accelerates the fall
swipe up - turns the figure 
tapping on the screen - pause
"""
    return label
  }()

  private lazy var button: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 20.0
    button.setTitle("OK", for: .normal)
    button.addTarget(self, action: #selector(okTouch), for: .touchUpInside)
    button.setTitleColor(.white, for: .normal)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .white
    view.addSubviews([titleLabel, label, button])
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    label.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).inset(-100)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    button.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(44)
      $0.width.equalTo(200)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
    }
  }

  @objc private func okTouch(_ sender: Any) {
    dismiss(animated: true)
  }
}
