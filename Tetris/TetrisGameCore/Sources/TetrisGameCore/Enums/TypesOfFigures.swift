//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation
import UIKit

public enum Shapes: Int {
    case O = 0
    case I
    case S
    case Z
    case L
    case J
    case T
    
    var color: UIColor {
        switch self {
        case .O: return .yellow
        case .I: return .cyan
        case .S: return .red
        case .Z: return .blue
        case .L: return .orange
        case .J: return .purple
        case .T: return .gray
        }
    }
    
    var coordinates: [(y: Int, x: Int)] {
        switch self {
        case .O: return [(0, 0), (0, 1), (1, 0), (1, 1)]
        case .I: return [(0, 0), (1, 0), (2, 0), (3, 0)]
        case .S: return [(0, 1), (0, 2), (1, 0), (1, 1)]
        case .Z: return [(0, 0), (0, 1), (1, 1), (1, 2)]
        case .L: return [(0, 0), (1, 0), (2, 0), (2, 1)]
        case .J: return [(0, 1), (1, 1), (2, 1), (2, 0)]
        case .T: return [(0, 0), (0, 1), (0, 2), (1, 1)]
        }
    }
}
