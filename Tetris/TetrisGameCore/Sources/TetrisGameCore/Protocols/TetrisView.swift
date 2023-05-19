import Foundation

protocol TetrisView {
    func endGame(scope: Int)
    func editScore(str: String)
}

public protocol TetrisCoreInput {
    var output: TetrisCoreOutput? { get set }
//    var generateFigure: GenerateFigureProtocol { get set }
    
    func start()
    func pause()
    func run()
    
    func left()
    func right()
    func down()
    func moves()
}

public protocol TetrisCoreOutput {
    func changingPoints(points: Int)
    func changingGameField(array: [[FieldCellStatuses]])
    func endGame(points: Int)
}

extension TetrisCoreInput {
//    var generateFigure = RandomGenerateFigure()
}
