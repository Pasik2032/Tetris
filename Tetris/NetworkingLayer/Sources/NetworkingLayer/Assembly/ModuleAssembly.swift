//
//  ModuleAssembly.swift
//  
//
//  Created by Arseny Drozdov on 01.08.2022.
//

import Swinject

public final class ModuleAssembly: Swinject.Assembly {
  // MARK: Public 
  public init() {}
  
  public func assemble(container: Container) {
    container.register(NetworkingProtocol.self) { resolver in
      Networking()
    }.inObjectScope(.container)
  }
}
