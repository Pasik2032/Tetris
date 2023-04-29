//
//  MTHeader.swift
//  
//
//  Created by Arseny Drozdov on 10.08.2022.
//

import Alamofire

public enum MTHeader {
  case locale
  case appVersion
  case authToken
  case specified(key: String, value: String)

  var header: HTTPHeader {
    switch self {
    case .locale:
      return .init(name: "locale", value: NetworkConfig.locale)
    case .appVersion:
      return .init(name: "AppVersion", value: NetworkConfig.appVersion)
    case .authToken:
      return .init(name: "XAuthToken", value: NetworkConfig.authToken ?? "")
    case .specified(let key, let value):
      return .init(name: key, value: value)
    }
  }
}

// MARK: Create HTTPHeaders
extension Array where Element == MTHeader {
  func httpHeaders() -> HTTPHeaders {
    var newHeader = self
    newHeader.append(.specified(key: "Content-Type", value: "application/json"))
    return .init(newHeader.map { $0.header })
  }
}
