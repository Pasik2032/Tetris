//
//  Optional + Extensions.swift
//  
//
//  Created by Arseny Drozdov on 02.08.2022.
//

import Foundation

extension Optional where Wrapped: Collection {
  var isNilOrEmpty: Bool {
    guard let collection = self else { return true }
    return collection.isEmpty
  }
}

extension Optional where Wrapped: Sendable {
  var isNil: Bool {
    guard let _ = self else { return true }
    return false
  }
}
