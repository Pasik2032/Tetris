//
//  WaitingRoomAssembly.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2023.
//

import Foundation
import Swinject

typealias WaitingRoom = WaitingRoomViewController

final class WaitingRoomAssembly: Swinject.Assembly {
  public func assemble(container: Container) {
    container.register(WaitingRoom.self) { resolver in
      let onlineService = resolver.resolve(OnlineServiceProtocol.self)!
      let presenter = WaitingRoomPresenter(onlineService: onlineService)
      let view = WaitingRoomViewController(presenter: presenter, nibName: "WaitingRoomViewController")
      presenter.view = view
      let router = WaitingRoomRouter(view: view)
      presenter.router = router
      return view
    }
  }
}
