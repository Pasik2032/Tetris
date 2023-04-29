//
//  SerializerError.swift
//  MGP_Test
//
//  Created by Arseny Drozdov on 20.05.2022.
//  Copyright © 2022 ISS. All rights reserved.
//

import Foundation

public enum SerializerDecodableError: Error {
    case invalidKeyPath
    case emptyKeyPath
    case invalidJSON
}

extension SerializerDecodableError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidKeyPath:   return "Nested object doesn't exist by this keyPath."
        case .emptyKeyPath:     return "KeyPath can not be empty."
        case .invalidJSON:      return "Invalid nested json."
        }
    }
}
