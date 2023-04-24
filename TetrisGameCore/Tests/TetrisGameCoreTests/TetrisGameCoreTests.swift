import XCTest
@testable import TetrisGameCore

final class TetrisGameCoreTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TetrisGameCore().gameStatus, GameStatuses.notStarted)
    }
}
