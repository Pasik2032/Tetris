//
//  Configure.swift
//  MTNetworking
//
//  Created by Arseny Drozdov on 14.07.2022.
//

import Foundation
import Alamofire

enum NetworkConfig {

  static var baseURL: String = "http://MacBook-Pro-10.local:8080/"
  static var socketURL: String = "ws://MacBook-Pro-10.local:8080/websocket"

  static var locale: String = "ru-Ru"
  static var appVersion: String = ""
  static var authToken: String?

  static var headers: [MTHeader] {
    var header: [MTHeader] = [
      .locale,
      .appVersion,
    ]

    if NetworkConfig.authToken != nil {
      header.append(.authToken)
    }
    return header
  }

  static let maxSideSizeInPx = 960
  static let maxSizeInMb: Float = 2.0

  static let rootQueue = DispatchQueue(label: "com.cs.tetris.af.root", qos: .userInitiated)
  static let requestQueue = DispatchQueue(label: "com.cs.tetris.af.request", qos: .userInitiated)
  static let serializationQueue = DispatchQueue(label: "com.cs.tetris.af.serialization", qos: .userInitiated)
  static let monitorQueue = DispatchQueue(label: "com.cs.tetris.af.monitor", qos: .utility)
}
