import XCTest
@testable import Yvim

class CommandModeYankTests: XCTestCase {
    func testYank() throws {
        let position = TextPosition("It's not as easy as you think",
                                    "         ^                   ")
        let editor = BufferEditorMock(position)
        let register = Register()
        let modeSwitcher = ModeSwitcherMock()
        let cmd = CommandModeYank(register: register, editor: editor, modeSwitcher: modeSwitcher)
        cmd.handle(textObject: TextObjects.InnerWord())
        XCTAssertEqual(editor.position, position)
        XCTAssertEqual(register.register as? TextRegisterValue, TextRegisterValue(text: "as"))
        XCTAssertTrue(modeSwitcher.inCommandMode)
    }

    func testYankLine() throws {
        let position = TextPosition("It's not\n as easy\n as you think",
                                    "             ^                   ")
        let editor = BufferEditorMock(position)
        let register = Register()
        let modeSwitcher = ModeSwitcherMock()
        let cmd = CommandModeYank(register: register, editor: editor, modeSwitcher: modeSwitcher)
        cmd.handle(textObject: TextObjects.Line(expansion: 0))
        XCTAssertEqual(editor.position, position)
        XCTAssertEqual(register.register as? LineRegisterValue, LineRegisterValue(text: " as easy\n"))
        XCTAssertTrue(modeSwitcher.inCommandMode)
    }

}
