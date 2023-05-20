//
//  GamePresenter.swift
//  Tetris
//
//  Created Даниил Пасилецкий on 13.05.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


final class GamePresenter {

  enum TypeGame {
    case single
    case multy
  }

  enum State {
    case seachPlane
    case waitStart
    case game
    case pause
  }

  init(type: TypeGame, gameService: GameServiceProtocol) {
    self.gameService = gameService
    self.type = type
    switch type {
    case .single:
      games = [Game(type: .device)]
    case .multy:
      games = [Game(type: .device), Game(type: .remoute)]
    }

    games.forEach { [weak self] in
      guard let self else { return }
      $0.output = self
    }

    self.gameService.output = self
  }

  // MARK: - Properties

  weak var view: GameViewInput?

  var games: [Game]
  var isWaitGame: Bool {
    state == .seachPlane
  }

  private var state: State = .seachPlane
  private var type: TypeGame
  private var gameService: GameServiceProtocol
}

// MARK: - GameViewOutput

extension GamePresenter: GameViewOutput {
  func swipe(direction: UISwipeGestureRecognizer.Direction) {
    guard
      let game = games.first(where: { $0.type == .device }),
      let action = Game.Action(swipe: direction),
      let a = ActionTetris(action)
    else { return }
    game.action(action)

    if case .multy = type {
      gameService.sendAction(action: a)
    }
  }

  func tap() {
    switch state {
    case .waitStart: startGame()
    case .game where type == .single: pause()
    case .game: break
    case .seachPlane: break
    case .pause: resume()
    }
  }

  func startGame() {
    guard let game = games.first(where: { $0.type == .device }) else { return }
    view?.setTouchLabel(isShow: false)
    state = .game
    switch type {
    case .single: game.start()
    case .multy: gameService.start()
    }
  }

  private func pause() {
    view?.setPause(isShow: true)
    state = .pause
  }

  private func resume() {
    view?.setPause(isShow: false)
    state = .game
  }

  func rendererScene() {
    state = .waitStart
    DispatchQueue.main.async { [weak self] in
      self?.view?.setTouchLabel(isShow: true)
    }
  }

  func viewDidLoad() {
    if case .multy = type {
      view?.showRemoutePoint()
      view?.pointRemouteDidChande(point: 0)
    }
  }
}

extension GamePresenter: GameOutput {
  func endGame(score: Int) {
    view?.showEndGame(point: score)
    state = .waitStart
  }

  func scoreDidChange(score: Int, game: Game.GameType) {
    switch game {
    case .remoute: view?.pointRemouteDidChande(point: score)
    case .device: view?.pointDidChande(point: score)
    }
  }
}

extension GamePresenter: GameServiceOutput {
  func startRemoutGame() {
    guard let game = games.first(where: { $0.type == .remoute }) else { return }
    game.core.start()
  }

  func setGenerate(figure: [Int]) {
    guard let game = games.first(where: { $0.type == .remoute }) else { return }
    game.setGenerate(figure: figure)
  }

  func action(_ action: ActionTetris) {
    guard let game = games.first(where: { $0.type == .remoute }) else { return }
    game.action(Game.Action(action: action))
  }
}
