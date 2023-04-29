//
//  UIViewController + Most.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import UIKit

public extension UIViewController {
  @objc static func topMost() -> UIViewController? {
    return UIApplication.getTopViewController()
  }
}

public extension UIApplication {
  class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

    if let nav = base as? UINavigationController {
      return getTopViewController(base: nav.visibleViewController)

    } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
      return getTopViewController(base: selected)

    } else if let presented = base?.presentedViewController {
      return getTopViewController(base: presented)
    }
    return base
  }
}
