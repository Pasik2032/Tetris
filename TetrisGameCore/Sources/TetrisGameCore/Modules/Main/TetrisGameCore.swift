import Foundation
import UIKit
import ARKit

public struct TetrisGameCore {
    public private(set) var gameStatus:               GameStatuses
    
    public private(set) var gameStartDate:            Date?
    public private(set) var gameFinishDate:           Date?
    public private(set) var timeAfterGameStarted:     Double
    
    public private(set) var lengthOfField:            Int
    public private(set) var widthOfField:             Int
    
    public private(set) var gameStatusOfFirstPlayer:  GameStatuses
    public private(set) var gameStatusOfSecondPlayer: GameStatuses
    public private(set) var scoreOfFirstPlayer:       Double
    public private(set) var scoreOfSecondPlayer:      Double
    public private(set) var fieldOfFirstPlayer:       [[FieldCellStatuses]]
    public private(set) var fieldOfSecondPlayer:      [[FieldCellStatuses]]
    
    private let generate: generateFigureProtocol

    private static let colors = [
        UIImage(named: "yellow"),
        UIImage(named: "cyan"),
        UIImage(named: "red"),
        UIImage(named: "blue"),
        UIImage(named: "orange"),
        UIImage(named: "pink"),
        UIImage(named: "gray")]


    let boxes: [[SCNNode]]
    var figure: [(Int, Int)]
    var color = UIImage(named: "yellow")
    var speed: Float
    var timer: Timer?
    public var scope : Int = 0 {
        didSet {
            speed -= 0.04
            view.editScore(str: String(scope))
            print("new speed " + String(speed))
        }
    }
    var shap: Shapes
    let view: TetrisView
    var count = 0

    init(_ boxes: [[SCNNode]], view: TetrisView, generate: generateFigureProtocol = randomGenerateFigure()) {
        self.boxes = TetrisEngine.clear(boxes)
        figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
        speed = 2
        shap = Shapes.O
        self.view = view
        self.generate = generate

    }
    
    public init(length: Int, width: Int) {
        gameStatus = .notStarted
        
        if #available(iOS 15, *) {
            gameStartDate = Date.now
        } else {
            // Исправить
            gameStartDate = nil
        }
        
        gameFinishDate = nil
        timeAfterGameStarted = 0.0
        
        lengthOfField = length
        widthOfField = width
        
        gameStatusOfFirstPlayer = .notStarted
        gameStatusOfSecondPlayer = .notStarted
        scoreOfFirstPlayer = 0.0
        scoreOfSecondPlayer = 0.0
        
        fieldOfFirstPlayer = [[FieldCellStatuses]]()
        fieldOfSecondPlayer = [[FieldCellStatuses]]()
        
        for i in 0..<length {
            fieldOfFirstPlayer.append([FieldCellStatuses]())
            fieldOfSecondPlayer.append([FieldCellStatuses]())
            
            for j in 0..<width {
                fieldOfFirstPlayer[i].append(FieldCellStatuses.free)
                fieldOfSecondPlayer[i].append(FieldCellStatuses.free)
            }
        }
    }
}
