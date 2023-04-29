//
//  UserAPI.swift
//  
//
//  Created by Даниил Пасилецкий on 02.11.2022.
//


import Alamofire

public enum UserAPI: APIProtocol {
  case fetchOnline

  public var path: String {
    switch self {
    case .fetchOnline: return "user/online"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .fetchOnline: return .get
    }
  }
}
