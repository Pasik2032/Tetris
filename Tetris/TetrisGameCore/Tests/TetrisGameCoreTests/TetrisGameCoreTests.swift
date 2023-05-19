import XCTest
@testable import TetrisGameCore

final class TetrisGameCoreTests: XCTestCase {
    var count = 6
    let changingPointArrAnswer = [0, 1, 2, 3, 4, 5]
    var newGameCore: TetrisGameCore = TetrisGameCore()
    
  
    
    func testExample() throws {
        let exp = expectation(description: "Wayt start")
        let c = TestTimer()
        
        c.endGame = {
            exp.fulfill()
        }
        
        
        
        
        
        print("here1")
       
        print("here2")
        newGameCore.output = c
        print("here3")
        self.newGameCore.start()
        
        if XCTWaiter.wait(for: [exp], timeout: 60.0) != .completed {
            XCTFail("No")
        }
        

        

        print("here4")
        newGameCore.left()
        print("here5")
        newGameCore.right()
        print("here6")
        
      
            while true {}
    }
}


class TestTimer: TetrisCoreOutput {
    func changingPoints(points: Int) {
        print(points)
    }
    
    func endGame(points: Int) {
        endGame?()
    }
    
    var endGame: (() -> Void)?
    
    func changingGameField(array: [[FieldCellStatuses]]) {
        for yCoordinate in 0..<20 {
            var str = ""
            
            for xCoordinate in 0..<10 {
                switch array[yCoordinate][xCoordinate] {
                case .free: str += "0"
                default: str += "1"
                }
            }
            
            print(str)
        }
    }
    
}
