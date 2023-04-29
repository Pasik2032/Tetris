//
//  AssemblyModuls.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 29.04.2023.
//

import Foundation
import Swinject
import NetworkingLayer

@objc public class Assembly: NSObject {
  private static let assemblies: [Swinject.Assembly] = [
    ModeSelectionAssembly(),
    UserServiceAssembly(),
    NetworkingLayer.ModuleAssembly(),
  ]

  private static let container = Container()
  private static let assembler = Assembler(assemblies, container: container)

  static let resolver = (assembler.resolver as! Container).synchronize()
}
