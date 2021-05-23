import XCTest
@testable import Yvim

class LineMotionTests: XCTestCase {

    // MARK: Forward

    func testForward() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n  ^    \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n   ^   \n   ")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardAtEndOfLine() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n      ^\n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n      ^\n   ")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardAtEndOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardNearEndOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n ^ ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testForwardAtBeginningOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               " ^   \n       \n   ")
        LineMotions.Forward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Backward

    func testBackward() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n  ^    \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n ^     \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardAtBeginningOfLine() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n^      \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n^      \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardAtBeginningOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardNearBeginningOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               " ^   \n       \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testBackwardAtEndOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n ^ ")
        LineMotions.Backward().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: LineStart

    func testLineStart() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n  ^    \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n^      \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineStartAtStartOfLine() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n^      \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n^      \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineStartNearBeginningOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "   ^ \n       \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineStartAtBeginningOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "^    \n       \n   ")
        LineMotions.LineStart().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: LineEnd

    func testLineEnd() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n  ^    \n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n      ^\n   ")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineEndAtEndOfLine() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n      ^\n   ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n      ^\n   ")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineEndNearEndOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n ^ ")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testLineEndAtEndOfText() {
        var pos = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        let exp = TextPosition("12345\nabcdefg\nABC",
                               "     \n       \n  ^")
        LineMotions.LineEnd().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Find

    func testFind() {
        var pos = TextPosition("onetwothree",
                               "    ^      ")
        let exp = TextPosition("onetwothree",
                               "      ^    ")
        LineMotions.Find(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindClose() {
        var pos = TextPosition("onetwothree",
                               "     ^     ")
        let exp = TextPosition("onetwothree",
                               "      ^    ")
        LineMotions.Find(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindNext() {
        var pos = TextPosition("onetwothree",
                               "   ^       ")
        let exp = TextPosition("onetwothree",
                               "      ^    ")
        LineMotions.Find(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindAtEndOfText() {
        var pos = TextPosition("onetwothree",
                               "          ^")
        let exp = TextPosition("onetwothree",
                               "          ^")
        LineMotions.Find(parameter: "e").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindNoMoreOccurence() {
        var pos = TextPosition("@onetwothree",
                               "    ^       ")
        let exp = TextPosition("@onetwothree",
                               "    ^       ")
        LineMotions.Find(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindNextLine() {
        var pos = TextPosition("@onetwothree\n@four",
                               "    ^       \n     ")
        let exp = TextPosition("@onetwothree\n@four",
                               "    ^       \n     ")
        LineMotions.Find(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: FindReverse

    func testFindReverse() {
        var pos = TextPosition("onetwothree",
                               "        ^  ")
        let exp = TextPosition("onetwothree",
                               "      ^    ")
        LineMotions.FindReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseClose() {
        var pos = TextPosition("onetwothree",
                               "       ^   ")
        let exp = TextPosition("onetwothree",
                               "      ^    ")
        LineMotions.FindReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseNext() {
        var pos = TextPosition("onetwothree",
                               "      ^    ")
        let exp = TextPosition("onetwothree",
                               "   ^       ")
        LineMotions.FindReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseAtBeginningOfText() {
        var pos = TextPosition("onetwothree",
                               "^          ")
        let exp = TextPosition("onetwothree",
                               "^          ")
        LineMotions.FindReverse(parameter: "o").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReverseNoMoreOccurence() {
        var pos = TextPosition("onetwothree@",
                               "    ^       ")
        let exp = TextPosition("onetwothree@",
                               "    ^       ")
        LineMotions.FindReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testFindReversePreviousLine() {
        var pos = TextPosition("onetwothree@\nfour@",
                               "            \n ^   ")
        let exp = TextPosition("onetwothree@\nfour@",
                               "            \n ^   ")
        LineMotions.FindReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Til

    func testTil() {
        var pos = TextPosition("onetwothree",
                               "    ^      ")
        let exp = TextPosition("onetwothree",
                               "     ^     ")
        LineMotions.Til(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNext() {
        var pos = TextPosition("onetwothree",
                               "  ^        ")
        let exp = TextPosition("onetwothree",
                               "     ^     ")
        LineMotions.Til(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilAtEndOfText() {
        var pos = TextPosition("onetwothree",
                               "          ^")
        let exp = TextPosition("onetwothree",
                               "          ^")
        LineMotions.Til(parameter: "e").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNearEndOfText() {
        var pos = TextPosition("onetwothree",
                               "         ^ ")
        let exp = TextPosition("onetwothree",
                               "         ^ ")
        LineMotions.Til(parameter: "e").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNoMoreOccurence() {
        var pos = TextPosition("@onetwothree",
                               "    ^       ")
        let exp = TextPosition("@onetwothree",
                               "    ^       ")
        LineMotions.Til(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilNextLine() {
        var pos = TextPosition("@onetwothree\n@four",
                               "    ^       \n     ")
        let exp = TextPosition("@onetwothree\n@four",
                               "    ^       \n     ")
        LineMotions.Til(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: TilReverse

    func testTilReverse() {
        var pos = TextPosition("onetwothree",
                               "         ^ ")
        let exp = TextPosition("onetwothree",
                               "       ^   ")
        LineMotions.TilReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseNext() {
        var pos = TextPosition("onetwothree",
                               "       ^   ")
        let exp = TextPosition("onetwothree",
                               "    ^      ")
        LineMotions.TilReverse(parameter: "t").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseAtBeginningOfText() {
        var pos = TextPosition("onetwothree",
                               "^          ")
        let exp = TextPosition("onetwothree",
                               "^          ")
        LineMotions.TilReverse(parameter: "o").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseNearBeginningOfText() {
        var pos = TextPosition("onetwothree",
                               " ^         ")
        let exp = TextPosition("onetwothree",
                               " ^         ")
        LineMotions.TilReverse(parameter: "o").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReverseNoMoreOccurence() {
        var pos = TextPosition("onetwothree@",
                               "     ^      ")
        let exp = TextPosition("onetwothree@",
                               "     ^      ")
        LineMotions.TilReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testTilReversePreviousLine() {
        var pos = TextPosition("onetwothree@\nfour@",
                               "            \n  ^  ")
        let exp = TextPosition("onetwothree@\nfour@",
                               "            \n  ^  ")
        LineMotions.TilReverse(parameter: "@").move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: End

    func testEnd() {
        var pos = TextPosition("this is suspicious",
                               "^                 ")
        let exp = TextPosition("this is suspicious",
                               "   ^              ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNext() {
        var pos = TextPosition("this is suspicious",
                               "   ^              ")
        let exp = TextPosition("this is suspicious",
                               "      ^           ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndInSpace() {
        var pos = TextPosition("this is suspicious",
                               "    ^             ")
        let exp = TextPosition("this is suspicious",
                               "      ^           ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndAcrossLines() {
        var pos = TextPosition("this is suspicious\nor not",
                               "                 ^\n      ")
        let exp = TextPosition("this is suspicious\nor not",
                               "                  \n ^    ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndInLastWordOfText() {
        var pos = TextPosition("this is suspicious",
                               "                 ^")
        let exp = TextPosition("this is suspicious",
                               "                 ^")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndAtEndOfText() {
        var pos = TextPosition("this is suspicious",
                               "                 ^")
        let exp = TextPosition("this is suspicious",
                               "                 ^")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndLeadingWhitespace() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "^                                            ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "       ^                                     ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndAlphanumeric() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "         ^                                   ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "               ^                        ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNonAlphanumeric() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "               ^                        ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "                ^                       ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNonAlphanumeric1() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "                ^                       ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "                         ^              ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndNonAlphanumeric2() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "                          ^             ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "                                    ^   ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndMultipleNonAlphanumeric1() {
        var pos = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "               ^                               ")
        let exp = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "                ^                         ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testEndMultipleNonAlphanumeric2() {
        var pos = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "                ^                         ")
        let exp = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "                 ^                        ")
        LineMotions.End().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    // MARK: Word

    func testWord() {
        let exp = TextPosition("that is suspicious",
                               "     ^            ")
        var pos = TextPosition("that is suspicious",
                               "  ^               ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNext() {
        var pos = TextPosition("this is suspicious",
                               "     ^            ")
        let exp = TextPosition("this is suspicious",
                               "        ^         ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordInSpace() {
        var pos = TextPosition("this is suspicious",
                               "    ^             ")
        let exp = TextPosition("this is suspicious",
                               "     ^            ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordAcrossLines() {
        var pos = TextPosition("this is suspicious\nor not",
                               "        ^         \n      ")
        let exp = TextPosition("this is suspicious\nor not",
                               "                  \n^     ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordInLastWordOfText() {
        var pos = TextPosition("this is suspicious",
                               "          ^       ")
        let exp = TextPosition("this is suspicious",
                               "                 ^")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordLeadingWhitespace() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "^                                            ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "    ^                                        ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordAlphanumeric() {
        var pos = TextPosition("abcd123 etc",
                               "^          ")
        let exp = TextPosition("abcd123 etc",
                               "        ^  ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNonAlphanumeric() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "         ^                                   ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "                ^                       ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNonAlphanumeric1() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "                ^                       ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "                 ^                      ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordNonAlphanumeric2() {
        var pos = TextPosition("    func abcd123(parameter: parameter) {",
                               "                          ^             ")
        let exp = TextPosition("    func abcd123(parameter: parameter) {",
                               "                            ^           ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordMultipleNonAlphanumeric1() {
        var pos = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "               ^                               ")
        let exp = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "                ^                         ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

    func testWordMultipleNonAlphanumeric2() {
        var pos = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "                ^                         ")
        let exp = TextPosition("    func abcd123(_ parameter: parameter) {",
                               "                 ^                        ")
        LineMotions.Word().move(&pos)
        XCTAssertEqual(pos, exp)
    }

}

