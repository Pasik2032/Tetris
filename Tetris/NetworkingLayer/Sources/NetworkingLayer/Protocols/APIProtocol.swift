//
//  APIProtocol.swift
//  MTNetworking
//
//  Created by Arseny Drozdov on 14.07.2022.
//

import Foundation
import Alamofire

/**
 Представляет описание `URL-запроса` на сервер

 - `path`: `Обязательный`, описывает `endpoint` для API
 - `method`: `Обязательный`, описывает метод запроса, пример: `.get`
 - `parameters`: `Необязательный`, описывает `body` запроса, пример: `"version": 5.1`
 - `headers`: `Необязательный`, описывает `header` запроса если требуется кастомный
 - `timeoutInterval`: `Необязательный`, описывает время, через которое запрос отзовется если не получит ответ

 - Note: `headers` и `timeoutInterval` имеют стандартные значения, их изменение переопределяется для конкретного API
*/
public protocol APIProtocol {
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: Parameters? { get }
  var headers: [MTHeader]? { get }
  var timeoutInterval: TimeInterval { get }
  var keyPath: String? { get }

  // В данный момент не используется
  var retryCount: Int { get }
}

extension APIProtocol {
  public var keyPath: String? {
    return nil
  }

  public var timeoutInterval: TimeInterval {
    return 120
  }

  public var headers: [MTHeader]? {
    return NetworkConfig.headers
  }

  public var parameters: Parameters? {
    return nil
  }

  public var retryCount: Int {
    return 0
  }

  func urlString() -> String {
    return NetworkConfig.baseURL + (path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? path)
  }
}
