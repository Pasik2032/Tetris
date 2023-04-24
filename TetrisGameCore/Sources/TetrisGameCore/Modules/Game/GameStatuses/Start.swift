//
//  File.swift
//  
//
//  Created by Сергей Абросов on 24.04.2023.
//

import Foundation

let semaphore = DispatchSemaphore(value: 1)

public func start(){
    shap = generate.generateFigure(count)
    count += 1

    switch shap {
    case .O:
        print("OK")
        figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
        color = TetrisEngine.colors[0]
    case .I:
        figure = [(20, 4),(19, 4), (18, 4), (17, 4)]
        color = TetrisEngine.colors[1]
    case .S:
        figure = [(19, 4),(19, 5), (18, 3), (18, 4)]
        color = TetrisEngine.colors[2]
    case .Z:
        figure = [(19, 3),(19, 4), (18, 4), (18, 5)]
        color = TetrisEngine.colors[3]
    case .L:
        figure = [(20, 4),(19, 4), (18, 4), (18, 5)]
        color = TetrisEngine.colors[4]
    case .J:
        figure = [(20, 4),(19, 4), (18, 4), (18, 3)]
        color = TetrisEngine.colors[5]
    case .T:
        figure = [(20, 4),(20, 5), (20, 6), (19, 5)]
        color = TetrisEngine.colors[6]
    }
    if boxes[figure[0].0][figure[0].1].name == "full" || boxes[figure[1].0][figure[1].1].name == "full" || boxes[figure[2].0][figure[2].1].name == "full" || boxes[figure[3].0][figure[3].1].name == "full"{
        print("Game over")
        print("Scope: " + String(scope))
        view.endGame(scope: scope)
        return
    }
    for cordinate in figure {
        boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
    }
    timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(fall), userInfo: nil, repeats: true)

//        RunLoop.main.add(timer!, forMode: .common)
    print("test")

}
