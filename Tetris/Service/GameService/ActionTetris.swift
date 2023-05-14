//
//  ActionTetris.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.05.2023.
//

import UIKit

enum ActionTetris: String {
  case left
  case right
  case up
  case down

  init?(_ a: Game.Action) {
    switch a {
    case .left: self = .left
    case .right: self = .right
    case .move: self = .up
    case .down: self = .down
    default: return nil
    }
  }
}
