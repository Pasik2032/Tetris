import Foundation
import UIKit

public class TetrisGameCore: TetrisCoreInput {
    
    // MARK: - Properties
    
    private var gameStatus: GameStatuses = .notStarted
    private var gameTimer: Timer?
    private var speed: Float = 2.0
    private var field: [[FieldCellStatuses]] {
        didSet {
            print("jr")
            output?.changingGameField(array: field)
        }
    }
    private var currentFigure: Figure?
    
    private var generate: GenerateProtocol
 
    private var score: Int = 0 {
        didSet {
            output?.changingPoints(points: score)
        }
    }
    
    private let lengthOfField: Int
    private let widthOfField: Int
    
    public var output: TetrisCoreOutput?
    
    public convenience init() {
        self.init(generate: RandomGenerate())
    }
    
    public init(generate: GenerateProtocol) {
        lengthOfField = 20
        widthOfField = 10
        self.generate = generate
        
        field = [[FieldCellStatuses]]()
        
        for i in 0..<lengthOfField {
            field.append([FieldCellStatuses]())
            
            for _ in 0..<widthOfField {
                field[i].append(FieldCellStatuses.free)
            }
        }
      print()
    }
}

extension TetrisGameCore {
    
    // MARK: - TetrisCoreInput
    
    public func start() {
        gameStatus = .inProgress
print("dfdf")
        guard var figureType = Shapes(rawValue: generate.generate()) else { return }
        currentFigure = Figure(length: lengthOfField, width: widthOfField, type: figureType)
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(speed),
            target: self,
            selector: #selector(gameProcess),
            userInfo: nil,
            repeats: true
        )
    }
    
    public func pause(){
        gameTimer?.invalidate()
    }

    public func run(){
        gameTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(speed),
            target: self,
            selector: #selector(gameProcess),
            userInfo: nil,
            repeats: true
        )
    }
    
    public func left() {
        guard let currentFigure else { return }
        var copyOfCurrentFigureCoordinates = currentFigure.coordinates
        
        for number in 0..<copyOfCurrentFigureCoordinates.count {
            copyOfCurrentFigureCoordinates[number].1 -= 1
        }
        
        if checkCoordinates(coordinates: copyOfCurrentFigureCoordinates) {
            currentFigure.coordinates = copyOfCurrentFigureCoordinates
        }
    }
    
    public func right() {
        guard let currentFigure else { return }
        var copyOfCurrentFigureCoordinates = currentFigure.coordinates
        
        for number in 0..<copyOfCurrentFigureCoordinates.count {
            copyOfCurrentFigureCoordinates[number].1 += 1
        }
        
        if checkCoordinates(coordinates: copyOfCurrentFigureCoordinates) {
            currentFigure.coordinates = copyOfCurrentFigureCoordinates
        }
    }
    
    public func down() {
        guard let currentFigure else { return }
        var copyOfCurrentFigureCoordinates = currentFigure.coordinates
        
        while checkCoordinates(coordinates: copyOfCurrentFigureCoordinates) {
            currentFigure.coordinates = copyOfCurrentFigureCoordinates
            
            for number in 0..<copyOfCurrentFigureCoordinates.count {
                copyOfCurrentFigureCoordinates[number].0 -= 1
            }
        }
    }
    
    public func moves() {
        guard let currentFigure else { return }
        var a, b, c, d : (Int, Int)
        
        a = currentFigure.coordinates[0]
        b = currentFigure.coordinates[1]
        c = currentFigure.coordinates[2]
        d = currentFigure.coordinates[3]
        
        switch currentFigure.type {
        case .O:
            print("shap o turn")
        case .I:
            if currentFigure.coordinates[1].0 == currentFigure.coordinates[2].0 + 1 {
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
            if currentFigure.coordinates[0].1 == currentFigure.coordinates[1].1 - 1 {
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
            if currentFigure.coordinates[0].1 == currentFigure.coordinates[1].1 - 1 {
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
            if currentFigure.coordinates[0].0 == currentFigure.coordinates[1].0 + 1 {
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
            if currentFigure.coordinates[0].0 == currentFigure.coordinates[1].0 + 1 {
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
        
        guard checkCoordinates(coordinates: [a, b, c, d]) else { return }
        
        currentFigure.coordinates.forEach {
            field[$0][$1] = .free
        }
        
        currentFigure.coordinates = [a, b, c, d]
        
        currentFigure.coordinates.forEach {
            field[$0][$1] = .busy(color: currentFigure.type.color)
        }
    }
    
    // Проверка возможности размещения фигуры в текущих координатах
    public func checkCoordinates(coordinates: [(Int, Int)]) -> Bool {
        for number in coordinates {
            if !(0..<20).contains(number.0) || !(0..<10).contains(number.1) {
                return false
            }
            
            switch (field[number.0][number.1]) {
            case .free:
                continue
            default:
                return false
            }
        }
        
        return true
    }
    
    private func clear() {
        field = [[FieldCellStatuses]]()
        
        for i in 0..<lengthOfField {
            field.append([FieldCellStatuses]())
            
            for _ in 0..<widthOfField {
                field[i].append(FieldCellStatuses.free)
            }
        }
    }
    
    private func deleteRows() {
        var arrayOfFulledRows = [Int]()
        
        for yCoordinate in 0..<lengthOfField {
            var check = true
            
            for xCoordinate in 0..<widthOfField {
                switch field[yCoordinate][xCoordinate] {
                case .free:
                    check = false
                    break
                default:
                    continue
                }
            }
            
            if check {
                arrayOfFulledRows.append(yCoordinate)
            }
        }
        
        score += arrayOfFulledRows.count
        
        arrayOfFulledRows.sort(by: >)
        for rowNumber in arrayOfFulledRows {
            field.remove(at: rowNumber)
            field.append([FieldCellStatuses]())
        }
    }
    
    @objc func gameProcess(timer: Timer) {
        guard var currentFigure else { return }
        var check = true
        print("we")
        for cord in currentFigure.freeCordinates {
            switch field[cord.0][cord.1] {
            case .free:
                continue
            default:
                check = false
                break
            }
        }
        
        // Заходим если фигура не может падать дальше
        if !check {
            timer.invalidate()
            
            for cord in currentFigure.coordinates {
                field[cord.0][cord.1] = .busy(color: currentFigure.type.color)
            }
            
            deleteRows()
            
            guard var figureType = Shapes(rawValue: generate.generate()) else { return }
            currentFigure = Figure(length: lengthOfField, width: widthOfField, type: figureType)
            
            gameTimer = Timer.scheduledTimer(
                timeInterval: TimeInterval(speed),
                target: self,
                selector: #selector(gameProcess),
                userInfo: nil,
                repeats: true
            )
            
            return
        }
        
        currentFigure.coordinates.forEach {
            field[$0][$1] = .free
        }
        
        for number in 0..<currentFigure.coordinates.count {
            currentFigure.coordinates[number].0 -= 1
        }
        
        currentFigure.coordinates.forEach {
            field[$0][$1] = .busy(color: currentFigure.type.color)
        }
    }
}
