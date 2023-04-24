//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

func deleteRow(){
    var i = 1
    while i <= 20 {
//        for i in 1...20{
        var flag = true
        for j in 0...9{
            if (boxes[i][j].name != "full") {
                flag = false
                break
            }
        }
        if flag {
            scope += 1
            for j in i...19{
                for k in 0...9{
                    if boxes[j+1][k].name == "full"{
                        boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                        boxes[j][k].geometry?.firstMaterial?.diffuse.contents = TetrisEngine.colors[Int.random(in: 0...6)]
                        boxes[j][k].name = "full"
                    } else {
                        boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                        boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                        boxes[j][k].name = "empty"
                    }
                }

            }
            i -= 1
        }
        i += 1
    }
}
