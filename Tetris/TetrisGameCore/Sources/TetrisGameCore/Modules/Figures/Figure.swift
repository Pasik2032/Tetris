//
//  File.swift
//  
//
//  Created by Сергей Абросов on 19.05.2023.
//

import Foundation
import UIKit

final class Figure {
    var coordinates: [(Int, Int)]
    var type: Shapes
    
    init(length: Int, width: Int, type: Shapes) {
        self.coordinates = type.coordinates.map { (length - $0 - 1, $1 + width / 2) }
        self.type = type
    }
    
    var freeCordinates: [(Int, Int)] {
        var container = [(Int, Int)]()
        
        for coordinate in coordinates {
            var check = true
            let copyCoordinate = (coordinate.0 - 1, coordinate.1)
            
            for cord in coordinates {
                if cord == copyCoordinate {
                    check = false
                    break
                }
            }
            
            if check {
                container.append(copyCoordinate)
            }
        }
        
        return container
    }
}
