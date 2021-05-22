import XCTest
@testable import Yvim

class TextObjectTests: XCTestCase {

    func testWord() {
        var rng = textRange("There once was a",
                            "       *        ")
        let exp = textRange("There once was a",
                            "      ****      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAlphanumeric() {
        var rng = textRange("There once123 was a",
                            "       *           ")
        let exp = textRange("There once123 was a",
                            "      *******      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordNonAlphanumeric1() {
        var rng = textRange("There (once123) was a",
                            "        *            ")
        let exp = textRange("There (once123) was a",
                            "       *******       ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordNonAlphanumeric2() {
        var rng = textRange("There (once123) was a",
                            "      *              ")
        let exp = textRange("There (once123) was a",
                            "      *              ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordInsideSpace() {
        var rng = textRange("There once was a",
                            "     *          ")
        let exp = textRange("There once was a",
                            "     *          ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordInsideSpaces() {
        var rng = textRange("There  once was a",
                            "     *           ")
        let exp = textRange("There  once was a",
                            "     *           ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAtBeginningOfWord() {
        var rng = textRange("There once was a",
                            "      *         ")
        let exp = textRange("There once was a",
                            "      ****      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAtEndOfWord() {
        var rng = textRange("There once was a",
                            "         *      ")
        let exp = textRange("There once was a",
                            "      ****      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testLine() {
        var rng = textRange("First.\nSecond.\nLast",
                            "       _ *      _    ")
        let exp = textRange("First.\nSecond.\nLast",
                            "       _********_   ")
        TextObjects.Line(expansion: 0).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testEmptyLine() {
        var rng = textRange("First.\n\nSecond.\nLast",
                            "       _*_        _    ")
        let exp = textRange("First.\n\nSecond.\nLast",
                            "       _* _       _    ")
        TextObjects.Line(expansion: 0).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testWithNext() {
        var rng = textRange("First.\nSecond.\nThird.\nLast",
                            "       _ *      _       _    ")
        let exp = textRange("First.\nSecond.\nThird.\nLast",
                            "       _********_*******_    ")
        TextObjects.Line(expansion: 1).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testWithPrevious() {
        var rng = textRange("First.\nSecond.\nThird.\nLast",
                            "       _        _  *    _    ")
        let exp = textRange("First.\nSecond.\nThird.\nLast",
                            "       _********_*******_    ")
        TextObjects.Line(expansion: -1).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    private func textRange(_ text: String, _ selection: String) -> Yvim.TextRange {
        var selection = selection
        selection.removeAll(where: { $0 == "_" })
        let start = text.distance(from: text.startIndex, to: selection.firstIndex(of: "*")!)
        let end = text.distance(from: text.startIndex, to: selection.lastIndex(of: "*")!)
        return TextRange(text: text as NSString, start: start, end: end)
    }

}
