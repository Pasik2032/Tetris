//
//  MTAPI.swift
//  
//
//  Created by Arseny Drozdov on 26.07.2022.
//

import Alamofire

public enum MTAPI {
  case user(_ api: UserAPI)

  var api: APIProtocol {
    switch self {
    case .user(let api): return api
    }
  }
}
