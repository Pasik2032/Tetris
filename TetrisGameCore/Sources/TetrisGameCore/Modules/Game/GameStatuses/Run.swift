//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

public func run(){

    timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(fall), userInfo: nil, repeats: true)
}
