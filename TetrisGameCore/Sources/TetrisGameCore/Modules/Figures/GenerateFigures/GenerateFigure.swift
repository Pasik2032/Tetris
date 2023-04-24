//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

protocol generateFigureProtocol {
    func generateFigure(_ index: Int) -> Shapes
}

class randomGenerateFigure: generateFigureProtocol{
    func generateFigure(_ index: Int) -> Shapes {
        let a = Int.random(in: 0...6)
        return Shapes(rawValue: a)!
    }
}
