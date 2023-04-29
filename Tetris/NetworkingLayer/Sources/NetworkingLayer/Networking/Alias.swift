//
//  Alias.swift
//  
//
//  Created by Arseny Drozdov on 08.08.2022.
//

import Alamofire

public typealias onSuccess<T: Decodable> = (_ model: T) -> Void
public typealias onSuccessCode = () -> Void

public typealias onFailure<F: Decodable> = (_ error: FailureResponse<F>) -> Void
public typealias onFailureObject<F: Decodable> = (_ model: F?) -> Void
public typealias onFailureCode = (AFError) -> Void
