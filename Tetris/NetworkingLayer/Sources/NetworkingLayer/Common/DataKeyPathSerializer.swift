//
//  DataKeyPathSerializer.swift
//  MGP_Test
//
//  Created by Arseny Drozdov on 20.05.2022.
//  Copyright © 2022 ISS. All rights reserved.
//

import Foundation
import Alamofire

final class DataKeyPathSerializer<SerializedObject: Decodable>: DataResponseSerializerProtocol {

    private let keyPath: String?
    private let decoder: JSONDecoder

    init(keyPath: String?, decoder: JSONDecoder = JSONDecoder()) {
        self.keyPath = keyPath
        self.decoder = decoder
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> SerializedObject {
        if let error = error {
            throw error
        }

        if let keyPath = self.keyPath {
            if keyPath.isEmpty {
              throw AFError.responseSerializationFailed(reason: .decodingFailed(error: SerializerDecodableError.emptyKeyPath))
            }

            let json = try JSONResponseSerializer().serialize(request: nil, response: response, data: data, error: nil)
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                guard JSONSerialization.isValidJSONObject(nestedJson) else {
                    throw AFError.responseSerializationFailed(reason: .decodingFailed(error: SerializerDecodableError.invalidJSON))
                }
                let data = try JSONSerialization.data(withJSONObject: nestedJson)
                let object = try decoder.decode(SerializedObject.self, from: data)
                return object
            }
            else {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: SerializerDecodableError.invalidKeyPath))
            }
        } else {
            let data = try DataResponseSerializer().serialize(request: nil, response: response, data: data, error: nil)
            let object = try self.decoder.decode(SerializedObject.self, from: data)
            return object
        }
    }
}
