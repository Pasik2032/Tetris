//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

public func turn() {
    var a, b, c, d : (Int, Int)
    a = figure[0]
    b = figure[1]
    c = figure[2]
    d = figure[3]
    switch shap {
    case .O:
        print("shap o turn")
    case .I:
        if figure[1].0 ==  figure[2].0 + 1{
            a.0 = b.0
            c.0 = b.0
            c.1 = b.1 + 1
            d.0 = b.0
            d.1 = b.1 + 2
            a.1 = b.1 - 1
        } else {
            a.1 = b.1
            c.1 = b.1
            d.1 = b.1
            a.0 = b.0 + 1
            c.0 = b.0 - 1
            d.0 = b.0 - 2
        }
    case .S:
        if figure[0].1 ==  figure[1].1 - 1{
            b.0 = a.0 + 1
            b.1 = a.1
            d.1 = a.1 + 1
            d.0 = a.0
            c.1 = d.1
            c.0 = d.0 - 1
        } else{
            b.0 = a.0
            b.1 = a.1 + 1
            d.1 = a.1
            d.0 = a.0 - 1
            c.1 = d.1 - 1
            c.0 = d.0
        }
    case .Z:
        if figure[0].1 ==  figure[1].1 - 1{
            a.1 = b.1
            a.0 = b.0 - 1
            c.0 = b.0
            c.1 = b.1 + 1
            d.1 = c.1
            d.0 = c.0 + 1
        } else {
            a.1 = b.1 - 1
            a.0 = b.0
            c.1 = b.1
            c.0 = b.0 - 1
            d.0 = c.0
            d.1 = c.1 + 1
        }
    case .L:
        if figure[0].0 == figure[1].0 + 1 {
            a.0 = b.0
            c.0 = b.0
            a.1 = b.1 - 1
            c.1 = b.1 + 1
            d.1 = c.1
            d.0 = b.0 + 1
        } else {
            a.0 = b.0 + 1
            a.1 = b.1
            c.0 = b.0 - 1
            c.1 = b.1
            d.0 = c.0
            d.1 = c.1 + 1
        }
    case .J:
        if figure[0].0 == figure[1].0 + 1 {
            a.0 = b.0
            c.0 = b.0
            a.1 = b.1 - 1
            c.1 = b.1 + 1
            d.1 = c.1
            d.0 = b.0 - 1
        } else {
            a.0 = b.0 + 1
            a.1 = b.1
            c.0 = b.0 - 1
            c.1 = b.1
            d.0 = c.0
            d.1 = c.1 - 1
        }
    case .T:
        if c.0 - 1 == d.0 {
            a.1 = c.1
            a.0 = c.0 - 1
            b.1 = c.1
            b.0 = c.0 + 1
            d.0 = c.0
            d.1 = c.1 + 1
        } else if c.0  == d.0 {
            a.0 = c.0
            a.1 = c.1 + 1
            b.0 = c.0
            b.1 = c.1 - 1
            d.1 = c.1
            d.0 = c.0 + 1
        } else {
            a.0 = c.0
            a.1 = c.1 + 1
            b.0 = c.0
            b.1 = c.1 - 1
            d.1 = c.1
            d.0 = c.0 - 1
        }
    }
    for i in [a, b, c, d]{
        if i.1 < 0 || i.1 > 9 || i.0 > 20 || i.0 < 0 || boxes[i.0][i.1].name == "full"{
            return
        }
    }
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
    }
    figure[0] = a
    figure[1] = b
    figure[2] = c
    figure[3] = d
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
//            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
    }
}
