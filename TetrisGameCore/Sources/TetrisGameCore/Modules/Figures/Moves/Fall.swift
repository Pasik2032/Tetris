//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

@objc func fall(timer: Timer){
    print("Timer")
    for cordinate in figure {
        if (cordinate.0 - 1 == 0 || boxes[cordinate.0 - 1][cordinate.1].name == "full"){
            timer.invalidate()
            print("new")
            for cor in figure {
                boxes[cor.0][cor.1].name = "full"
            }
            deleteRow()
            start()
            return
        }
    }

    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
    }
    for i in 0..<4 {
        figure[i].0 -= 1
    }
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
        print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
    }
}
