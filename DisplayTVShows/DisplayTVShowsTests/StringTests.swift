import XCTest
@testable import DisplayTVShows

class StringTests: XCTestCase {
    var text = "B E N"

    func testRemovewWhiteSpace() {
        XCTAssertEqual("BEN", text.removingWhitespaces)
    }
}
