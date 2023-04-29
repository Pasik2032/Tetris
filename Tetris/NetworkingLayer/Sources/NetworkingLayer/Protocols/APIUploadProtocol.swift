//
//  APIUploadProtocol.swift
//  
//
//  Created by Arseny Drozdov on 27.07.2022.
//

import UIKit
import Alamofire

public protocol APIUploadProtocol {
    var path: String { get }
    var headers: [MTHeader] { get }
    var image: UIImage { get }
    var name: String { get }
    var fileName: String { get }
}

extension APIUploadProtocol {

  public var headers: [MTHeader] {
    return NetworkConfig.headers
  }

  func urlString() -> String {
    return NetworkConfig.baseURL + path
  }
}
