//
//  DataRequest + Extension.swift
//  NotificationService
//
//  Created by Arseny Drozdov on 23.05.2022.
//  Copyright © 2022 ISS. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {

    @discardableResult
    func responseDecodableObject<T: Decodable>(
      queue: DispatchQueue = .main,
      keyPath: String? = nil,
      decoder: JSONDecoder = JSONDecoder(),
      completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {

        return response(
          queue: queue,
          responseSerializer: DataKeyPathSerializer<T>(keyPath: keyPath, decoder: decoder),
          completionHandler: completionHandler
        )
    }
}
