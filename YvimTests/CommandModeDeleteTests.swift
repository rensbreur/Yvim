import XCTest
@testable import Yvim

class CommandModeDeleteTests: XCTestCase {
    func testDeleteText() throws {
        let position = TextPosition("It's not as easy as you think",
                                    "         ^                   ")
        let editor = BufferEditorMock(position)
        let register = Register()
        let operationMemory = OperationMemory()
        let modeSwitcher = ModeSwitcherMock()
        let cmd = CommandModeDelete(register: register, operationMemory: operationMemory, editor: editor, modeSwitcher: modeSwitcher)
        cmd.handle(textObject: TextObjects.InnerWord())
        XCTAssertEqual(editor.position, TextPosition("It's not  easy as you think",
                                                     "         ^                 "))
        XCTAssertEqual(register.register as? TextRegisterValue, TextRegisterValue(text: "as"))
        XCTAssertTrue(modeSwitcher.inCommandMode)
    }

    func testDeleteRepeat() throws {
        let position = TextPosition("It's not as easy as you think",
                                    "         ^                   ")
        let editor = BufferEditorMock(position)
        let register = Register()
        let operationMemory = OperationMemory()
        let modeSwitcher = ModeSwitcherMock()
        let cmd = CommandModeDelete(register: register, operationMemory: operationMemory, editor: editor, modeSwitcher: modeSwitcher)
        cmd.handle(textObject: TextObjects.InnerWord())
        let newPosition = TextPosition("It's easy like you think",
                                       "        ^               ")
        let newEditor = BufferEditorMock(newPosition)
        operationMemory.mostRecentCommand?.perform(newEditor)
        XCTAssertEqual(newEditor.position, TextPosition("It's  like you think",
                                                        "     ^              "))
        XCTAssertEqual(register.register as? TextRegisterValue, TextRegisterValue(text: "easy"))
        XCTAssertTrue(modeSwitcher.inCommandMode)
    }

    func testDeleteLine() throws {
        let position = TextPosition("It's not\n as easy\n as you think",
                                    "        \n    ^   \n             ")
        let editor = BufferEditorMock(position)
        let register = Register()
        let operationMemory = OperationMemory()
        let modeSwitcher = ModeSwitcherMock()
        let cmd = CommandModeDelete(register: register, operationMemory: operationMemory, editor: editor, modeSwitcher: modeSwitcher)
        cmd.handle(textObject: TextObjects.Line(expansion: 0))
        XCTAssertEqual(editor.position, TextPosition("It's not\n as you think",
                                                     "        \n^            "))
        XCTAssertEqual(register.register as? LineRegisterValue, LineRegisterValue(text: " as easy\n"))
        XCTAssertTrue(modeSwitcher.inCommandMode)
    }

}
