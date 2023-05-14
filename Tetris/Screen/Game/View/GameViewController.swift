//
//  GameViewController.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 13.05.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ARKit

protocol GameViewInput: AnyObject {
  func setPause(isShow: Bool)
  func setTouchLabel(isShow: Bool)
  func showEndGame(point: Int)
  func pointDidChande(point: Int)
  func pointRemouteDidChande(point: Int)
  func showRemoutePoint()
}

protocol GameViewOutput: AnyObject, ARAdapterDelegate {
  func viewDidLoad()
  func swipe(direction: UISwipeGestureRecognizer.Direction)
  func tap()
}

final class GameViewController: UIViewController {

  // MARK: - UI

  private var sceneView: ARSCNView = ARSCNView()

  // Shows score
  private lazy var scoreLabel: UILabel = {
    let control = PaddingLabel()
    control.topInset = 10
    control.bottomInset = 10
    control.leftInset = 10
    control.rightInset = 10
    control.backgroundColor = .black.withAlphaComponent(0.5)
    control.textColor = .white
    control.font = control.font.withSize(30)
    control.text = String(0)
    control.layer.cornerRadius = 10.0
    return control
  }()

  private lazy var remouteScoreLabel: UILabel = {
    let control = PaddingLabel()
    control.isHidden = true
    control.topInset = 10
    control.bottomInset = 10
    control.leftInset = 10
    control.rightInset = 10
    control.backgroundColor = .red.withAlphaComponent(0.5)
    control.textColor = .white
    control.font = control.font.withSize(30)
    control.text = String(0)
    control.layer.cornerRadius = 10.0
    return control
  }()

  private lazy var pauseLabel: UILabel = {
    let control = PaddingLabel()
    control.topInset = 40
    control.bottomInset = 40
    control.leftInset = 10
    control.rightInset = 10
    control.textColor = .white
    control.font = control.font.withSize(50)
    control.text = "Pause"
    control.isHidden = true
    control.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  // Label Game Over
  private lazy var gameOverLabel: UILabel = {
    let control = PaddingLabel()
    control.topInset = 30
    control.bottomInset = 30
    control.leftInset = 10
    control.rightInset = 10
    control.numberOfLines = 3
    control.isHidden = true
    control.textAlignment = .center
    control.textColor = .white
    control.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    control.font = control.font.withSize(30)
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  private lazy var touchLabel: UILabel = {
    let control = PaddingLabel()
    control.numberOfLines = 0
    control.rightInset = 10
    control.leftInset = 10
    control.topInset = 10
    control.isHidden = true
    control.bottomInset = 10
    control.textAlignment = .center
    control.layer.cornerRadius = 30
    control.textColor = .white
    control.text = "Нажмите на экран что бы начать игру"
    control.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    control.layer.cornerRadius = 10.0
    control.font = control.font.withSize(30)
    return control
  }()

  private var arAdapter: ARAdapter?

  // MARK: - Properties

  var presenter: GameViewOutput

  // MARK: - UIViewController

  init(presenter: GameViewOutput) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
    setupUI()
    self.arAdapter = ARAdapter(sceneView: sceneView, presenter: presenter)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    arAdapter?.config()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    arAdapter?.pause()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
    view.addSubview(sceneView)
    sceneView.frame = view.frame
    sceneView.addSubviews([
      scoreLabel,
      touchLabel,
      pauseLabel,
      gameOverLabel,
      remouteScoreLabel,
    ])
    makeConstraints()
    ConfigSwipes()
  }

  private func makeConstraints() {
    scoreLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(5)
      $0.leading.equalToSuperview().inset(16.0)
    }

    remouteScoreLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(5)
      $0.trailing.equalToSuperview().inset(16.0)
    }

    touchLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(50.0)
      $0.centerY.equalToSuperview()
    }

    pauseLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    gameOverLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  fileprivate func ConfigSwipes() {
    let swipeRight  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
    let swipeLeft  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
    let swipeDown  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
    let swipeUp  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
    let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tap))

    swipeUp.direction = UISwipeGestureRecognizer.Direction.up
    swipeDown.direction = UISwipeGestureRecognizer.Direction.down
    swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
    swipeRight.direction = UISwipeGestureRecognizer.Direction.right

    sceneView.addGestureRecognizer(gesture)
    sceneView.addGestureRecognizer(swipeRight)
    sceneView.addGestureRecognizer(swipeLeft)
    sceneView.addGestureRecognizer(swipeDown)
    sceneView.addGestureRecognizer(swipeUp)
  }

  @objc func tap(sender: UITapGestureRecognizer) {
    presenter.tap()
  }

  @objc func swipe(sender: UISwipeGestureRecognizer) {
    presenter.swipe(direction: sender.direction)
  }
}

// MARK: - TroikaServiceViewInput

extension GameViewController: GameViewInput {
  func pointRemouteDidChande(point: Int) {
    remouteScoreLabel.text = String(point)
  }

  func showRemoutePoint() {
    remouteScoreLabel.isHidden = false
  }

  func setPause(isShow: Bool) {
    pauseLabel.isHidden = !isShow
  }

  func setTouchLabel(isShow: Bool) {
    touchLabel.isHidden = !isShow
  }

  func showEndGame(point: Int) {
    gameOverLabel.isHidden = false
    gameOverLabel.text = "Game over\n Scope: \(String(point)) \ntab to start a new game"
  }

  func pointDidChande(point: Int) {
    scoreLabel.text = String(point)
  }
}
