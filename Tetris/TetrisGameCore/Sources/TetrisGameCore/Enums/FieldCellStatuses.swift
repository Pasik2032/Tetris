//
//  File.swift
//  
//
//  Created by Сергей Абросов on 23.04.2023.
//

import Foundation
import UIKit

public enum FieldCellStatuses {
    case free
    case busy(color: UIColor)
    
    static func ~=(_ lhs: FieldCellStatuses, _ rhs: FieldCellStatuses) -> Bool {
        switch (lhs, rhs) {
        case (.free, .free):
            return true
        case (.busy, .busy):
            return true
        default:
            return false
        }
    }
}
