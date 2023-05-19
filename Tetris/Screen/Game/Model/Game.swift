//
//  Game.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.05.2023.
//

import SceneKit
import TetrisGameCore

protocol GameOutput {
  func scoreDidChange(score: Int, game: Game.GameType)
}


final class Game {
  var field: [[SCNNode]] = [[]] {
    didSet {
      print("!!!\(field.count)")
    }
  }
  let type: GameType
  var core: TetrisCoreInput

  var output: GameOutput?

  private var generateFigures: [Int] = []

  init(type: GameType) {
    self.type = type
    switch type {
      case .device:
      self.core = TetrisGameCore()
    case .remoute:
      self.core = TetrisGameCore()
    }
    self.core.output = self
  }

  func action(_ a: Action) {
    print("!!\(a)")
    switch a {
    case .left: core.left()
    case .right: core.right()
    case .pause: core.pause()
    case .resume: core.run()
    case .down: core.down()
    case .move: core.moves()
    }
  }

  func start() {
    field.removeFirst()
    print("Start")
    self.core.start()
  }

  func setGenerate(figure: [Int]) {
    print("!!!!\(figure)")
//    self.core.generateFigure = self
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
  func changingGameField(array: [[FieldCellStatuses]]) {

    for y in 0..<array.count {
      for x in 0..<array[y].count {
        switch array[y][x] {
        case .busy(let color):
          print("AAAAAAAAAAAAAAAAAA")
          field[y][x].geometry?.firstMaterial?.diffuse.contents = color
        case .free:
          field[y][x].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        }
      }
    }
  }

  func endGame(points: Int) {
    print("END")
  }

  func changingPoints(points: Int) {
    output?.scoreDidChange(score: points, game: type)
  }
}

extension Game: GenerateProtocol {
  func generate() -> Int {
    guard let fig = generateFigures.first else { return 0 }
    generateFigures.removeLast()
    return fig
  }
}

//class TetrisMock: TetrisCoreInput {
//  var generateFigure: TetrisGenerat?
//
//  var output: TetrisCoreOutput?
//
//  func start() {
//    print("Start")
//  }
//
//  func left() {
//    print("left")
//  }
//
//  func right() {
//    print("right")
//  }
//
//  func up() {
//    print("up")
//  }
//
//  func down() {
//    print("down")
//  }
//
//  func pause() { }
//  func resume() { }
//}
////
////protocol TetrisGenerat {
////  func generate() -> Int
////}
//
////protocol TetrisCoreInput {
////  var output: TetrisCoreOutput? { get set }
////  var generateFigure: TetrisGenerat? { get set }
////  func start()
////  func left()
////  func right()
////  func pause()
////  func resume()
////  func up()
////  func down()
////}
////
////protocol TetrisCoreOutput {
////  func changingPoints(points: Int)
////}
