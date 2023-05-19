//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

public protocol GenerateProtocol {
    func generate() -> Int
}

public class RandomGenerate: GenerateProtocol {
    public func generate() -> Int {
        return Int.random(in: 0...6)
    }
}
