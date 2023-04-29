//
//  Logger.swift
//  MTNetworking
//
//  Created by apple on 14.07.2022.
//

import Foundation
import Alamofire

final class Logger: EventMonitor {
  let queue = NetworkConfig.monitorQueue

  func request(
    _ request: Request,
    didFailTask task: URLSessionTask,
    earlyWithError error: AFError
  ) {
    log(task: task, error: error)
  }

  func requestDidCancel(_ request: Request) {
    log(request: request)
  }

  func requestDidFinish(_ request: Request) {

  }

  func request<Value>(
    _ request: DataRequest,
    didParseResponse response: DataResponse<Value, AFError>
  ) {
    guard case let .responseSerializationFailed(reason) = response.error,
          case let .decodingFailed(error) = reason,
          let decodingError = error as? DecodingError else {
      return
    }
    var reasonString = ""
    switch decodingError {
    case .typeMismatch(let key, let context):
      reasonString = "Type: '\(key)' mismatch: \(String(describing: context.debugDescription))\ncodingPath: \(context.codingPath)"
    case .valueNotFound(let key, let context):
      reasonString = "Value: '\(key)' not found: \(String(describing: context.debugDescription))\ncodingPath: \(context.codingPath)"
    case .keyNotFound(let key, let context):
      reasonString = "Key: '\(key)' not found: \(String(describing: context.debugDescription))\ncodingPath: \(context.codingPath)"
    case .dataCorrupted(let context):
      reasonString = ""
    }
      print(
      """

      🆘🆘🆘 Ошибка сериаллизации данных

      ⚠️ URL: \(response.response?.url?.absoluteString ?? "")

      ⚠️ LocalizedDescription: \(error.localizedDescription)


      ⚠️ Reason: \(reasonString)

      ⚠️ FailureReason: \(String(describing: decodingError.failureReason))
      ⚠️ ErrorDescription: \(String(describing: decodingError.errorDescription))
      ⚠️ RecoverySuggestion: \(String(describing: decodingError.recoverySuggestion))

      🆘🆘🆘 ––––––––––––––––––––––– 🆘🆘🆘

      """
    )
  }
}

extension Logger {
  private func log(task: URLSessionTask, error: AFError) {
    DispatchQueue.main.async {
    print(
      """
      🆘🆘🆘 Ошибка запроса

      ⚠️ URL: \(task.response?.url?.absoluteString ?? "")

      ⚠️ ResponseCode: \(error.responseCode ?? -1)
      ⚠️ LocalizedDescription: \(error.localizedDescription)

      🆘🆘🆘 ––––––––––––––––––––––––––––––– 🆘🆘🆘
      """
    )
    }
  }

  private func log(request: Request) {
    print(
      """
      Cancel
      """
    )
  }
}
