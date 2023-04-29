//
//  UIView + setupUI.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}
