//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

public func shiftToLeft() {
    if figure[0].1 == 0 || figure[2].1 == 0 || figure[1].1 == 0 || figure[3].1 == 0{
        return
    }
    for cordinate in figure {
        if boxes[cordinate.0][cordinate.1 - 1].name == "full" {
            return
        }
    }

    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
    }
    for i in 0..<4 {
        figure[i].1 -= 1
    }
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
        print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
    }
}

public func shiftToRight() {
    if figure[1].1 == 9 || figure[3].1 == 9 || figure[0].1 == 9 || figure[2].1 == 9 {
        return
    }
    for cordinate in figure {
        if boxes[cordinate.0][cordinate.1 + 1].name == "full" {
            return
        }
    }
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
    }
    for i in 0..<4 {
        figure[i].1 += 1
    }
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
        print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
    }
}

public func shiftDown(){

    timer?.invalidate()
    timer = Timer(timeInterval: 0.02, target: self, selector: #selector(fall), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common)
//        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fall), userInfo: nil, repeats: true)
}
