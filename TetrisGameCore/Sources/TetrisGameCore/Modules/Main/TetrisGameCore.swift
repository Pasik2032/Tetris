import Foundation
import UIKit

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
