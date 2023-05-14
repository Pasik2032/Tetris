//
//  Game.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.05.2023.
//

import SceneKit

protocol GameOutput {
  func scoreDidChange(score: Int, game: Game.GameType)
}


final class Game {
  var field: [[SCNNode]] = [[]]
  let type: GameType
  var core: TetrisCoreInput

  var output: GameOutput?

  private var generateFigures: [Int] = []

  init(type: GameType) {
    self.type = type
    self.core = TetrisMock()
    self.core.output = self
  }

  func action(_ a: Action) {
    switch a {
    case .left: core.left()
    case .right: core.right()
    case .pause: core.pause()
    case .resume: core.resume()
    case .down: core.down()
    case .move: core.up()
    }
  }

  func start() {
    self.core.start()
  }

  func setGenerate(figure: [Int]) {
    print("!!!!\(figure)")
    self.core.generateFigure = self
    self.generateFigures = figure
  }

  enum GameType {
    case remoute
    case device
  }

  enum Action {
    case left
    case right
    case move
    case down
    case pause
    case resume

    init?(swipe: UISwipeGestureRecognizer.Direction) {
      switch swipe {
      case .down: self = .down
      case .right: self = .right
      case .left: self = .left
      case .up: self = .move
      default: return nil
      }
    }

    init(action: ActionTetris) {
      switch action {
      case .left: self = .left
      case .right: self = .right
      case .up: self = .move
      case .down: self = .down
      }
    }
  }
}

extension Game: TetrisCoreOutput {
  func changingPoints(points: Int) {
    output?.scoreDidChange(score: points, game: type)
  }
}

extension Game: TetrisGenerat {
  func generate() -> Int {
    guard let fig = generateFigures.first else { return 0 }
    generateFigures.removeLast()
    return fig
  }
}

class TetrisMock: TetrisCoreInput {
  var generateFigure: TetrisGenerat?

  var output: TetrisCoreOutput?

  func start() {
    print("Start")
  }

  func left() {
    print("left")
  }

  func right() {
    print("right")
  }

  func up() {
    print("up")
  }

  func down() {
    print("down")
  }

  func pause() { }
  func resume() { }
}

protocol TetrisGenerat {
  func generate() -> Int
}

protocol TetrisCoreInput {
  var output: TetrisCoreOutput? { get set }
  var generateFigure: TetrisGenerat? { get set }
  func start()
  func left()
  func right()
  func pause()
  func resume()
  func up()
  func down()
}

protocol TetrisCoreOutput {
  func changingPoints(points: Int)
}
