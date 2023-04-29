//
//  FailureResponse.swift
//  
//
//  Created by Arseny Drozdov on 28.07.2022.
//

import Alamofire
import SwiftyJSON

public struct FailureResponse<T: Decodable> {
  public var title = ""
  public var message = ""
  public var code: Int?
  public var codeString: String?

  /// Тип ошибки
  public var type: NetworkError<T>?

  /// Полный ответ от сервера
  public var response: AFDataResponse<T>?

  /// Добавляется в случае ошибки сериализации, хранит что не удалось спарсить
  public var userInfo: [String: Any]?
}

public enum NetworkError<T: Decodable> {
  case userUnauthorized(response: AFDataResponse<T>?)
  case internetUnvailable(response: AFDataResponse<T>?)
  case canBeParsed(json: JSON)
  case timeout(code: Int)
  case cancelled
  case notFound
  case decoding
  case unspecified(error: AFError?)

  var failureResponse: FailureResponse<T> {
    var failureResponse = FailureResponse<T>()
    switch self {
    case .userUnauthorized(let response):
      failureResponse.message = "Пользователь не авторизован"
      failureResponse.code = 401
      failureResponse.response = response
      failureResponse.type = .userUnauthorized(response: response)
    case .internetUnvailable(let response):
      failureResponse.title = "Нет соединения"
      failureResponse.message = "Интернет соединение отсутствует. Пожалуйста, проверьте его и попробуйте еще раз"
      failureResponse.code = -1004
      failureResponse.response = response
      failureResponse.type = .internetUnvailable(response: response)
    case .cancelled:
      failureResponse.message = "Клиент отменил запрос"
      failureResponse.title = "Запрос отменен"
      failureResponse.code = -999
      failureResponse.type = .cancelled
    case .timeout(let code):
      failureResponse.message = "Долго ждем запрос, что-то не так..."
      failureResponse.title = "Время вышло"
      failureResponse.code = code
      failureResponse.type = .timeout(code: code)
    case .notFound:
      failureResponse.message = "Нам не удалось найти"
      failureResponse.code = 404
      failureResponse.type = .notFound
    case .decoding:
      failureResponse.message = "Невозможно обработать данные"
      failureResponse.title = "Ошибка сериаллизации данных"
      failureResponse.type = .decoding  
    case .unspecified(let error):
      failureResponse.title = "Что-то пошло не так..."
      failureResponse.message = error?.errorDescription ?? ""
      failureResponse.code = error?.responseCode
      failureResponse.type = .unspecified(error: error)
    case .canBeParsed(let json):
      failureResponse.title = json["name"].stringValue
      failureResponse.message = json["message"].stringValue
      failureResponse.code = json["code"].int
      if failureResponse.code == nil {
        failureResponse.codeString = json["code"].string
      }
      failureResponse.type = .canBeParsed(json: json)
    }
    return failureResponse
  }
}
