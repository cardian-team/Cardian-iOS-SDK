import XCTest
@testable import Cardian

final class CardianTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Cardian().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
