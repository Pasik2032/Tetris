//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

static public func clear(_ boxes: [[SCNNode]]) -> [[SCNNode]]{
    for i in boxes{
        for j in i {
            j.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            j.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
            j.name = "empty"
        }
    }
    return boxes
}
