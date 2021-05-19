import XCTest
@testable import Yvim

class TextObjectTests: XCTestCase {

    func testInnerWord() {
        var rng = textRange("There once was a",
                            "       ^        ")
        let exp = textRange("There once was a",
                            "      ^^^^      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAlphanumeric() {
        var rng = textRange("There once123 was a",
                            "       ^           ")
        let exp = textRange("There once123 was a",
                            "      ^^^^^^^      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordNonAlphanumeric1() {
        var rng = textRange("There (once123) was a",
                            "        ^            ")
        let exp = textRange("There (once123) was a",
                            "       ^^^^^^^       ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordNonAlphanumeric2() {
        var rng = textRange("There (once123) was a",
                            "      ^              ")
        let exp = textRange("There (once123) was a",
                            "      ^              ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordInsideSpace() {
        var rng = textRange("There once was a",
                            "     ^          ")
        let exp = textRange("There once was a",
                            "     ^          ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordInsideSpaces() {
        var rng = textRange("There  once was a",
                            "     ^           ")
        let exp = textRange("There  once was a",
                            "     ^           ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    private func textRange(_ text: String, _ selection: String) -> Yvim.TextRange {
        let start = text.distance(from: text.startIndex, to: selection.firstIndex(of: "^")!)
        let end = text.distance(from: text.startIndex, to: selection.lastIndex(of: "^")!)
        return TextRange(text: text as NSString, start: start, end: end)
    }

}
