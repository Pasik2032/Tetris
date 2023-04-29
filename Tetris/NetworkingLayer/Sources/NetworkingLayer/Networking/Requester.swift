//
//  Requester.swift
//  MTNetworking
//
//  Created by Arseny Drozdov on 14.07.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - MTNetworkingProtocol
public protocol NetworkingProtocol: AnyObject {

  /// Создает запрос на основе `enum`, подписанного под `APIProtocol`
  ///
  /// - Parameters:
  ///   - API: enum's case содержащий неободимые для запроса проперти. Является протоколом.
  ///   - onSuccess: возвращает сериализованную структуру в случае успешного запроса, необходимо указать <T>
  ///   - onFailure: возвращает `FailureResponse<T>`, содержащий  ошибку с кастомным описанием
  ///
  /// ```
  /// // Example:
  /// .request(.charge(station(id: "123")), onSuccess: { (model: ECSModel) in
  ///   <your code>
  /// }) { error in
  ///   <your error handler>
  /// }
  /// ```
  ///
  /// - Returns:`DataRequest` – запрос, для `cancel` в случае необходимости
  /// - Note: `<T>` – `Decolable` структура для сериализации
  /// - Note: Возвращаемый объект не обязательно обрабатывать
  @discardableResult
  func request<T: Decodable>(
    API: MTAPI,
    onSuccess: @escaping onSuccess<T>,
    onFailure: @escaping onFailure<T>
  ) -> DataRequest

  /// Создает запрос на основе `enum`, подписанного под `APIProtocol`.
  /// Декодирует ошибку в передаваемую `Decodable` структуру
  ///
  /// - Parameters:
  ///   - API: enum's case содержащий неободимые для запроса проперти. Является протоколом.
  ///   - onSuccess: возвращает сериализованную структуру в случае успешного запроса, необходимо указать <T>
  ///   - onFailure: возвращает `FailureResponse<T>`, содержащий  ошибку с кастомным описанием
  ///
  /// ```
  /// // Example:
  /// .request(.charge(station(id: "123")), onSuccess: { (model: ECSModel) in
  ///   <your code>
  /// }) { (error: ECSErrorModel) in
  ///   <your error handler>
  /// }
  /// ```
  ///
  /// - Returns:`DataRequest` – запрос, для `cancel` в случае необходимости
  /// - Note: `<T>` – `Decolable` структура для сериализации `success`
  /// - Note: `<F>` – `Decolable` структура для сериализации `failure`
  /// - Note: Возвращаемый объект не обязательно обрабатывать
  @discardableResult
  func request<T: Decodable, F: Decodable>(
    API: MTAPI,
    onSuccess: @escaping onSuccess<T>,
    onFailureModel: @escaping onFailureObject<F>
  ) -> DataRequest

  /// Создает запрос на основе `enum`, подписанного под `APIProtocol`.
  /// Ошибка обрабатывается в рамках `HTTP-code`
  ///
  /// - Parameters:
  ///   - API: enum's case содержащий неободимые для запроса проперти. Является протоколом.
  ///   - onSuccessCode: возвращает ответ, в случае `code 200`
  ///   - onFailureCode: возвращает `AFError`
  ///
  /// ```
  /// // Example:
  /// .request(.charge(station(id: "123")), onSuccess: { (model: ECSModel) in
  ///   <your code>
  /// }) { (error: ECSErrorModel) in
  ///   <your error handler>
  /// }
  /// ```
  ///
  /// - Returns:`DataRequest` – запрос, для `cancel` в случае необходимости
  @discardableResult
  func request(
    API: MTAPI,
    onSuccess: @escaping onSuccessCode,
    onFailure: @escaping onFailureCode
  ) -> DataRequest

  /// Создает запрос на основе `enum`, подписанного под `APIUploadProtocol`
  ///
  /// - Parameters:
  ///   - API: enum's case содержащий неободимые для запроса проперти. Является протоколом.
  ///   - onSuccess: возвращает `JSON` объект в случае успешного запроса
  ///   - onFailure: возвращает `AFError`, содержащий  ошибку с описанием
  ///
  /// ```
  /// // Example:
  /// .request(.charge(station(id: "123")), onSuccess: { (model: JSON) in
  ///   <your code>
  /// }) { error in
  ///   <your error handler>
  /// }
  /// ```
  ///
  /// - Returns:`DataRequest` – запрос, для `cancel` в случае необходимости
  /// - Note: `<T>` – `Decolable` структура для сериализации
  /// - Note: Возвращаемый объект не обязательно обрабатывать
  func uploadImage<P: APIUploadProtocol>(
    API: P,
    onSuccessJSON: @escaping onSuccess<JSON>,
    onFailure: @escaping (AFError?) -> Void
  )

  /// Обновление констант для работы с разными стендами независимо от другого модуля
  ///
  /// - Parameters:
  ///   - baseURL: текущий юрл на стенд
  ///   - locale: текущая локализация
  ///   - appVersion: текущая версия приложения
  ///   - authToken: текущий токен клиента
  func updateConstants(
    baseURL: String,
    locale: String,
    appVersion: String,
    authToken: String?
  )
}

// MARK: - MTNetworking
final public class Networking {

  public init() {}

  private var availableCodes = 200...299

  /// Создание кастомной сессии для лаконичной настройки под  нужды
  private var session: Session = {
//    let trustManager = ServerTrustManager(evaluators: [
//      AppConfigType.prod.baseUrl: DefaultTrustEvaluator(),
//      AppConfigType.dev.baseUrl: DefaultTrustEvaluator(),
//      AppConfigType.stage.baseUrl: DefaultTrustEvaluator()
//    ])
    let monitor = Logger()

    let configuration = Session(
      rootQueue: NetworkConfig.rootQueue,
      requestQueue: NetworkConfig.requestQueue,
      serializationQueue: NetworkConfig.serializationQueue,
      eventMonitors: [monitor]
    )
    return configuration
  }()
}

// MARK: - MTNetworkingProtocol

extension Networking: NetworkingProtocol {
  @discardableResult
  public func request<T: Decodable, F: Decodable>(
    API: MTAPI,
    onSuccess: @escaping onSuccess<T>,
    onFailureModel: @escaping onFailureObject<F>
  ) -> DataRequest {
    let request = createRequest(API: API.api).responseDecodableObject(keyPath: API.api.keyPath) { (response: AFDataResponse<T>) in
      guard
        let value = response.value,
        self.availableCodes.contains(response.response?.statusCode ?? 0)
      else {
        if let data = response.data {
          do {
            onFailureModel(try JSONDecoder().decode(F.self, from: data))
          } catch {
            onFailureModel(nil)
          }
        } else {
          onFailureModel(nil)
        }

        return
      }
      onSuccess(value)
    }
    return request
  }

  @discardableResult
  public func request<T: Decodable>(
    API: MTAPI,
    onSuccess: @escaping onSuccess<T>,
    onFailure: @escaping onFailure<T>
  ) -> DataRequest {
    let request = createRequest(API: API.api).responseDecodableObject(keyPath: API.api.keyPath) { (response: AFDataResponse<T>) in
      guard
        let value = response.value,
        self.availableCodes.contains(response.response?.statusCode ?? 0)
      else {
        onFailure(self.parseErrorData(
          response: response,
          error: response.error).failureResponse
        )
        return
      }
      onSuccess(value)
    }
    return request
  }

  @discardableResult
  public func request(
    API: MTAPI,
    onSuccess: @escaping onSuccessCode,
    onFailure: @escaping onFailureCode
  ) -> DataRequest {
    let request = createRequest(API: API.api).responseData { response in
      guard self.availableCodes.contains(response.response?.statusCode ?? 0) else {
        onFailure(response.error ?? .explicitlyCancelled)
        return
      }
      onSuccess()
    }
    return request
  }
  
  public func uploadImage<P: APIUploadProtocol>(
    API: P,
    onSuccessJSON: @escaping onSuccess<JSON>,
    onFailure: @escaping (AFError?) -> Void
  ) {
    let image = API.image.resizeImage(NetworkConfig.maxSideSizeInPx)
    let imgData = image.jpegDataMaxSize(NetworkConfig.maxSizeInMb)

#if TARGET_INTERFACE_BUILDER
    //      MGCrashlyticsLogService.log(finalUrl, header: NetworkUtils.httpHeaders, parameters: nil)
#endif


    session.upload(
      multipartFormData: { multipartFormData in
        multipartFormData.append(
          imgData,
          withName: API.name,
          fileName: API.fileName,
          mimeType: "image/jpeg"
        )
      },
      to: API.urlString(),
      headers: API.headers.httpHeaders()
    ).uploadProgress(closure: { (progress) in
      /// progress handler
    }).responseDecodable(of: JSON.self) { response in
      guard let value = response.value else {
        onFailure(response.error)
        return
      }
      onSuccessJSON(JSON(value))
    }
  }

  public func updateConstants(
    baseURL: String,
    locale: String,
    appVersion: String,
    authToken: String?
  ) {
    NetworkConfig.baseURL = baseURL
    NetworkConfig.locale = locale
    NetworkConfig.appVersion = appVersion
    NetworkConfig.authToken = authToken
  }
}

// MARK: Private func
extension Networking {
  /// Создание `DataRequest` и отправка на сервер
  private func createRequest(API: APIProtocol) -> DataRequest {
    var headers: HTTPHeaders
    if let header = API.headers {
      headers = header.httpHeaders()
    } else {
      headers = NetworkConfig.headers.httpHeaders()
    }

    let encoding: ParameterEncoding =
    API.method == .get
    ? URLEncoding(destination: .queryString)
    : JSONEncoding.default

    return session.request(
      API.urlString(),
      method: API.method,
      parameters: API.parameters,
      encoding: encoding,
      headers: headers
    ) {
      $0.timeoutInterval = API.timeoutInterval
    }
  }

  /// Парсинг ошибки для вывода кастомной `FailureResponse`
  private func parseErrorData<T: Decodable>(response: AFDataResponse<T>?, error: AFError?) -> NetworkError<T> {

    switch error?.responseCode {
    case URLError.cancelled.rawValue:
      return .cancelled
    case URLError.timedOut.rawValue, -1001:
      return .timeout(code: URLError.timedOut.rawValue)
    case 401:
      return .userUnauthorized(response: response)
    case 404:
      return .notFound
    case URLError.networkConnectionLost.rawValue, URLError.notConnectedToInternet.rawValue, URLError.cannotFindHost.rawValue, URLError.cannotConnectToHost.rawValue:
      return .internetUnvailable(response: response)
    /// Alamofire конвертирует коды отсутствия интерента в свои https://github.com/Alamofire/Alamofire/issues/3470
    case 13:
      return .internetUnvailable(response: response)
    default:
      break
    }

    if error?.isExplicitlyCancelledError ?? false {
      return .cancelled
    }

    if let data = response?.data, let json = try? JSON(data: data) {
      return .canBeParsed(json: json)
    }

    if error?.isResponseSerializationError ?? false || error?.isResponseValidationError ?? false {
      return .decoding
#if TARGET_INTERFACE_BUILDER
      //          MGCrashlyticsLogService.logApiResponse(failResponse.message, apiRequest: url)
#endif
    }

#if TARGET_INTERFACE_BUILDER
    //      MGCrashlyticsLogService.logApiRequestFail(failResponse.message, apiRequest: url)
#endif
    return .unspecified(error: error?.asAFError)
  }
}
