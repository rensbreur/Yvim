import XCTest
@testable import Yvim

class TextObjectTests: XCTestCase {

    func testWord() {
        var rng = TextRange("There once was a",
                            "       *        ")
        let exp = TextRange("There once was a",
                            "      ****      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAlphanumeric() {
        var rng = TextRange("There once123 was a",
                            "       *           ")
        let exp = TextRange("There once123 was a",
                            "      *******      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordNonAlphanumeric1() {
        var rng = TextRange("There (once123) was a",
                            "        *            ")
        let exp = TextRange("There (once123) was a",
                            "       *******       ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordNonAlphanumeric2() {
        var rng = TextRange("There (once123) was a",
                            "      *              ")
        let exp = TextRange("There (once123) was a",
                            "      *              ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordInsideSpace() {
        var rng = TextRange("There once was a",
                            "     *          ")
        let exp = TextRange("There once was a",
                            "     *          ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordInsideSpaces() {
        var rng = TextRange("There  once was a",
                            "     *           ")
        let exp = TextRange("There  once was a",
                            "     *           ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAtBeginningOfWord() {
        var rng = TextRange("There once was a",
                            "      *         ")
        let exp = TextRange("There once was a",
                            "      ****      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testInnerWordAtEndOfWord() {
        var rng = TextRange("There once was a",
                            "         *      ")
        let exp = TextRange("There once was a",
                            "      ****      ")
        TextObjects.InnerWord().expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testLine() {
        var rng = TextRange("First.\nSecond.\nLast",
                            "       _ *      _    ")
        let exp = TextRange("First.\nSecond.\nLast",
                            "       _********_   ")
        TextObjects.Line(expansion: 0).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testEmptyLine() {
        var rng = TextRange("First.\n\nSecond.\nLast",
                            "       _*_        _    ")
        let exp = TextRange("First.\n\nSecond.\nLast",
                            "       _* _       _    ")
        TextObjects.Line(expansion: 0).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testWithNext() {
        var rng = TextRange("First.\nSecond.\nThird.\nLast",
                            "       _ *      _       _    ")
        let exp = TextRange("First.\nSecond.\nThird.\nLast",
                            "       _********_*******_    ")
        TextObjects.Line(expansion: 1).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

    func testWithPrevious() {
        var rng = TextRange("First.\nSecond.\nThird.\nLast",
                            "       _        _  *    _    ")
        let exp = TextRange("First.\nSecond.\nThird.\nLast",
                            "       _********_*******_    ")
        TextObjects.Line(expansion: -1).expand(&rng)
        XCTAssertEqual(rng, exp)
    }

}
