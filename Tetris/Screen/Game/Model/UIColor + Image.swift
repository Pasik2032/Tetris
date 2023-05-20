//
//  UIColor + Image.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 20.05.2023.
//

import UIKit

extension UIColor {
  var imageBox: UIImage? {
    switch self {
    case .yellow: return UIImage(named: "yellow")
    case .cyan: return UIImage(named: "cyan")
    case .red: return UIImage(named: "red")
    case .blue: return UIImage(named: "blue")
    case .orange: return UIImage(named: "orange")
    case .purple: return UIImage(named: "pink")
    case .gray: return UIImage(named: "gray")
    default: return UIImage(named: "box")
    }
  }
}
