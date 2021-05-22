import XCTest
@testable import Yvim

class LineMotionTests: XCTestCase {

    // MARK: Forward

    func testForward() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n  ^    \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n   ^   \n   ")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardAtEndOfLine() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n      ^\n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n      ^\n   ")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardAtEndOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardNearEndOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n       \n ^ ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardAtBeginningOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          " ^   \n       \n   ")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Backward

    func testBackward() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n  ^    \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n ^     \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardAtBeginningOfLine() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n^      \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n^      \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardAtBeginningOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardNearBeginningOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          " ^   \n       \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardAtEndOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n       \n ^ ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: LineStart

    func testLineStart() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n  ^    \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n^      \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineStartAtStartOfLine() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n^      \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n^      \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineStartNearBeginningOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "   ^ \n       \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineStartAtBeginningOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "^    \n       \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: LineEnd

    func testLineEnd() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n  ^    \n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n      ^\n   ")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineEndAtEndOfLine() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n      ^\n   ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n      ^\n   ")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineEndNearEndOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n       \n ^ ")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineEndAtEndOfText() {
        var pos = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        let exp = textPos("12345\nabcdefg\nABC",
                          "     \n       \n  ^")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Find

    func testFind() {
        var pos = textPos("onetwothree",
                          "    ^      ")
        let exp = textPos("onetwothree",
                          "      ^    ")
        LineMotions.Find(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindClose() {
        var pos = textPos("onetwothree",
                          "     ^     ")
        let exp = textPos("onetwothree",
                          "      ^    ")
        LineMotions.Find(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindNext() {
        var pos = textPos("onetwothree",
                          "   ^       ")
        let exp = textPos("onetwothree",
                          "      ^    ")
        LineMotions.Find(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindAtEndOfText() {
        var pos = textPos("onetwothree",
                          "          ^")
        let exp = textPos("onetwothree",
                          "          ^")
        LineMotions.Find(parameter: "e").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindNoMoreOccurence() {
        var pos = textPos("@onetwothree",
                          "    ^       ")
        let exp = textPos("@onetwothree",
                          "    ^       ")
        LineMotions.Find(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindNextLine() {
        var pos = textPos("@onetwothree\n@four",
                          "    ^       \n     ")
        let exp = textPos("@onetwothree\n@four",
                          "    ^       \n     ")
        LineMotions.Find(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: FindReverse

    func testFindReverse() {
        var pos = textPos("onetwothree",
                          "        ^  ")
        let exp = textPos("onetwothree",
                          "      ^    ")
        LineMotions.FindReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseClose() {
        var pos = textPos("onetwothree",
                          "       ^   ")
        let exp = textPos("onetwothree",
                          "      ^    ")
        LineMotions.FindReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseNext() {
        var pos = textPos("onetwothree",
                          "      ^    ")
        let exp = textPos("onetwothree",
                          "   ^       ")
        LineMotions.FindReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseAtBeginningOfText() {
        var pos = textPos("onetwothree",
                          "^          ")
        let exp = textPos("onetwothree",
                          "^          ")
        LineMotions.FindReverse(parameter: "o").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseNoMoreOccurence() {
        var pos = textPos("onetwothree@",
                          "    ^       ")
        let exp = textPos("onetwothree@",
                          "    ^       ")
        LineMotions.FindReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReversePreviousLine() {
        var pos = textPos("onetwothree@\nfour@",
                          "            \n ^   ")
        let exp = textPos("onetwothree@\nfour@",
                          "            \n ^   ")
        LineMotions.FindReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Til

    func testTil() {
        var pos = textPos("onetwothree",
                          "    ^      ")
        let exp = textPos("onetwothree",
                          "     ^     ")
        LineMotions.Til(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNext() {
        var pos = textPos("onetwothree",
                          "  ^        ")
        let exp = textPos("onetwothree",
                          "     ^     ")
        LineMotions.Til(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilAtEndOfText() {
        var pos = textPos("onetwothree",
                          "          ^")
        let exp = textPos("onetwothree",
                          "          ^")
        LineMotions.Til(parameter: "e").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNearEndOfText() {
        var pos = textPos("onetwothree",
                          "         ^ ")
        let exp = textPos("onetwothree",
                          "         ^ ")
        LineMotions.Til(parameter: "e").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNoMoreOccurence() {
        var pos = textPos("@onetwothree",
                          "    ^       ")
        let exp = textPos("@onetwothree",
                          "    ^       ")
        LineMotions.Til(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNextLine() {
        var pos = textPos("@onetwothree\n@four",
                          "    ^       \n     ")
        let exp = textPos("@onetwothree\n@four",
                          "    ^       \n     ")
        LineMotions.Til(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: TilReverse

    func testTilReverse() {
        var pos = textPos("onetwothree",
                          "         ^ ")
        let exp = textPos("onetwothree",
                          "       ^   ")
        LineMotions.TilReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseNext() {
        var pos = textPos("onetwothree",
                          "       ^   ")
        let exp = textPos("onetwothree",
                          "    ^      ")
        LineMotions.TilReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseAtBeginningOfText() {
        var pos = textPos("onetwothree",
                          "^          ")
        let exp = textPos("onetwothree",
                          "^          ")
        LineMotions.TilReverse(parameter: "o").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseNearBeginningOfText() {
        var pos = textPos("onetwothree",
                          " ^         ")
        let exp = textPos("onetwothree",
                          " ^         ")
        LineMotions.TilReverse(parameter: "o").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseNoMoreOccurence() {
        var pos = textPos("onetwothree@",
                          "     ^      ")
        let exp = textPos("onetwothree@",
                          "     ^      ")
        LineMotions.TilReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReversePreviousLine() {
        var pos = textPos("onetwothree@\nfour@",
                          "            \n  ^  ")
        let exp = textPos("onetwothree@\nfour@",
                          "            \n  ^  ")
        LineMotions.TilReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: End

    func testEnd() {
        var pos = textPos("this is suspicious",
                          "^                 ")
        let exp = textPos("this is suspicious",
                          "   ^              ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNext() {
        var pos = textPos("this is suspicious",
                          "   ^              ")
        let exp = textPos("this is suspicious",
                          "      ^           ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndInSpace() {
        var pos = textPos("this is suspicious",
                          "    ^             ")
        let exp = textPos("this is suspicious",
                          "      ^           ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndAcrossLines() {
        var pos = textPos("this is suspicious\nor not",
                          "                 ^\n      ")
        let exp = textPos("this is suspicious\nor not",
                          "                  \n ^    ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndInLastWordOfText() {
        var pos = textPos("this is suspicious",
                          "                 ^")
        let exp = textPos("this is suspicious",
                          "                 ^")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndAtEndOfText() {
        var pos = textPos("this is suspicious",
                          "                 ^")
        let exp = textPos("this is suspicious",
                          "                 ^")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndLeadingWhitespace() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "^                                       ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "       ^                                ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndAlphanumeric() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "         ^                              ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "               ^                        ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNonAlphanumeric() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "               ^                        ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "                ^                       ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNonAlphanumeric1() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "                ^                       ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "                         ^              ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNonAlphanumeric2() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "                          ^             ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "                                    ^   ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndMultipleNonAlphanumeric1() {
        var pos = textPos("    func abcd123(_ parameter: parameter) {",
                          "               ^                          ")
        let exp = textPos("    func abcd123(_ parameter: parameter) {",
                          "                ^                         ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndMultipleNonAlphanumeric2() {
        var pos = textPos("    func abcd123(_ parameter: parameter) {",
                          "                ^                         ")
        let exp = textPos("    func abcd123(_ parameter: parameter) {",
                          "                 ^                        ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Word

    func testWord() {
        var pos = textPos("this is suspicious",
                          "  ^               ")
        let exp = textPos("this is suspicious",
                          "     ^            ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNext() {
        var pos = textPos("this is suspicious",
                          "     ^            ")
        let exp = textPos("this is suspicious",
                          "        ^         ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordInSpace() {
        var pos = textPos("this is suspicious",
                          "    ^             ")
        let exp = textPos("this is suspicious",
                          "     ^            ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordAcrossLines() {
        var pos = textPos("this is suspicious\nor not",
                          "        ^         \n      ")
        let exp = textPos("this is suspicious\nor not",
                          "                  \n^     ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordInLastWordOfText() {
        var pos = textPos("this is suspicious",
                          "          ^       ")
        let exp = textPos("this is suspicious",
                          "                 ^")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordLeadingWhitespace() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "^                                       ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "    ^                                   ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordAlphanumeric() {
        var pos = textPos("abcd123 etc",
                          "^          ")
        let exp = textPos("abcd123 etc",
                          "        ^  ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNonAlphanumeric() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "         ^                              ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "                ^                       ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNonAlphanumeric1() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "                ^                       ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "                 ^                      ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNonAlphanumeric2() {
        var pos = textPos("    func abcd123(parameter: parameter) {",
                          "                          ^             ")
        let exp = textPos("    func abcd123(parameter: parameter) {",
                          "                            ^           ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordMultipleNonAlphanumeric1() {
        var pos = textPos("    func abcd123(_ parameter: parameter) {",
                          "               ^                          ")
        let exp = textPos("    func abcd123(_ parameter: parameter) {",
                          "                ^                         ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordMultipleNonAlphanumeric2() {
        var pos = textPos("    func abcd123(_ parameter: parameter) {",
                          "                ^                         ")
        let exp = textPos("    func abcd123(_ parameter: parameter) {",
                          "                 ^                        ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    private func textPos(_ text: String, _ cursor: String) -> TextPosition {
        let position = text.distance(from: text.startIndex, to: cursor.firstIndex(of: "^")!)
        return TextPosition(text: text as NSString, position: position)
    }

}
