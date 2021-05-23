@testable import Yvim
import XCTest

class CommandHandlerParametrizedTests: XCTestCase {
    let key: Character = "d"

    func testUnrelated() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "y")
        XCTAssertEqual(command.textObjects.count, 0)
    }

    func testOnLine() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "dd")
        XCTAssertEqual(command.textObjects.count, 1)
        XCTAssertEqual(command.textObjects[0] as? TextObjects.Line, TextObjects.Line(expansion: 0))
    }

    func testTwoLines() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "2dd")
        XCTAssertEqual(command.textObjects.count, 1)
        XCTAssertEqual(command.textObjects[0] as? TextObjects.Line, TextObjects.Line(expansion: 1))
    }

    func testTwoLinesAsMotionMultiplier() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "d2d")
        XCTAssertEqual(command.textObjects.count, 1)
        XCTAssertEqual(command.textObjects[0] as? TextObjects.Line, TextObjects.Line(expansion: 1))
    }

    func testUp() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "dk")
        XCTAssertEqual(command.textObjects.count, 1)
        XCTAssertEqual(command.textObjects[0] as? TextObjects.Line, TextObjects.Line(expansion: -1))
    }

    func testDown() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "dj")
        XCTAssertEqual(command.textObjects.count, 1)
        XCTAssertEqual(command.textObjects[0] as? TextObjects.Line, TextObjects.Line(expansion: 1))
    }

    func testMotion() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "dw")
        XCTAssertEqual(command.textObjects.count, 1)
        let textObject = try XCTUnwrap(command.textObjects[0] as? TextObjects.FromMotion)
        let motion = try XCTUnwrap(textObject.motion as? LineMotionMultiplied)
        XCTAssertEqual(motion.multiplier, 1)
        XCTAssertNotNil(motion.motion as? LineMotions.Word)
    }

    func testMultipliedMotion() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "d2w")
        XCTAssertEqual(command.textObjects.count, 1)
        let textObject = try XCTUnwrap(command.textObjects[0] as? TextObjects.FromMotion)
        let motion = try XCTUnwrap(textObject.motion as? LineMotionMultiplied)
        XCTAssertEqual(motion.multiplier, 2)
        XCTAssertNotNil(motion.motion as? LineMotions.Word)
    }

    func testMultipliedMotionCommand() throws {
        let command = MockCommand()
        let commandHandler = createReader(command)
        commandHandler.feed(string: "2dw")
        XCTAssertEqual(command.textObjects.count, 1)
        let textObject = try XCTUnwrap(command.textObjects[0] as? TextObjects.FromMotion)
        let motion = try XCTUnwrap(textObject.motion as? LineMotionMultiplied)
        XCTAssertEqual(motion.multiplier, 2)
        XCTAssertNotNil(motion.motion as? LineMotions.Word)
    }

    private func createReader(_ command: MockCommand) -> Reader {
        let multiplier = MultiplierReader()
        let commandHandler = CommandHandlerParametrized(self.key, multiplier: multiplier, command: command)
        return SequentialReader([multiplier, commandHandler])
    }

}

private class MockCommand: ParametrizedEditorCommand {
    var textObjects: [TextObject] = []

    func handle(textObject: TextObject) {
        textObjects.append(textObject)
    }

}
