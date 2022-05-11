//
//  MultyPlayerPresenter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 10.05.2022.
//

import UIKit

protocol MultyPlayerPresenterProtocol {
    func swipe(str:String)
    func back()
}

class MultyPlayerPresenter: MultyPlayerPresenterProtocol {
    func back() {
        network.requestGame(str: "exit")
    }

    func swipe(str: String) {
        network.requestGame(str: str)
    }
    
    var shapes: [Shapes] = []{
        didSet{
            print("new shapes")
        }
    }
    var count = 0
    weak var engineFirst: TetrisEngine?
    var view: MultyPlayerViewProtocol?
    weak var engineSecond: TetrisEngine?

    private lazy var network = NetworkWebTocken.getNetworkGame()

    private func parseShapes(input: [String.SubSequence]) {
        var arr: [Shapes] = []
        for (iter, i) in input.enumerated() {
            if iter == 0 {
                continue
            }
            arr.append(Shapes(rawValue: Int(i) ?? 0)!)
        }
        shapes = arr
    }

    public var isFirstEnd: Bool = false
    public var isSecondEnd: Bool = false
    public func endGame(isFist: Bool){
        if isFist {
            isFirstEnd = true
            network.requestGame(str: "finish")
        } else {
            isSecondEnd = true
        }
        if isFirstEnd, isSecondEnd{
            view?.showEnd(i: engineFirst?.scope ?? 0, you: engineSecond?.scope ?? 0)
        }

    }

    public func start(){
        setip()
        network.requestGame(str: "ready")
    }

    init() {
        setip()
    }

    private func setip(){
        network.responseGame {  input in
            let subStr = input.split(separator: " ")
            if subStr.count != 1 {
                self.parseShapes(input: subStr)
                return
            }
            print("Обработал строку \(input)")
                switch input  {
                case "left": self.engineSecond?.shiftToLeft()
                case "game":
                    DispatchQueue.main.async {
                        self.engineFirst?.start()
                        self.engineSecond?.start()
                    }
                case "right": self.engineSecond?.shiftToRight()
                case "down": self.engineSecond?.shiftDown()
                case "up": self.engineSecond?.turn()
                case "cancel":
                    DispatchQueue.main.async {
                    self.view?.showNot(handel: { action in
                    switch action.style {
                    case .cancel:
                        DispatchQueue.main.async {
                            self.view?.dis()
                        }
                        NetworkWebTocken.shared.status = .online
                        break
                    default :
                        print("error")
                    }
                    })}
                default: print("Не обработал команду: \(input)")
                }

        }
    }
}

extension MultyPlayerPresenter: generateFigureProtocol {

    func generateFigure(_ index: Int) -> Shapes {

        DispatchQueue.global().async { [self] in
            if shapes.count  - index < 10 {
                network.requestGame(str: "generation")
            }
        }
        return shapes[index]
    }

}
