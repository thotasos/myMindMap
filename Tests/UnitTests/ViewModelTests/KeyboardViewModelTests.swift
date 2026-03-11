import XCTest
import SwiftUI
@testable import myMindMap

final class KeyboardViewModelTests: XCTestCase {

    var viewModel: KeyboardViewModel!

    override func setUpWithError() throws {
        viewModel = KeyboardViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // MARK: - Initialization Tests

    func testDefaultInitialization() throws {
        XCTAssertFalse(viewModel.isCommandMode)
        XCTAssertEqual(viewModel.lastKeyPress, "")
    }

    // MARK: - Navigation Key Tests

    func testTabKey() throws {
        let result = viewModel.handleKeyPress(.tab, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Tab")
        XCTAssertFalse(result) // Should return false for non-command keys
    }

    func testReturnKey() throws {
        let result = viewModel.handleKeyPress(.return, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Return")
        XCTAssertFalse(result)
    }

    func testDeleteKey() throws {
        let result = viewModel.handleKeyPress(.delete, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Delete")
        XCTAssertFalse(result)
    }

    func testEscapeKey() throws {
        let result = viewModel.handleKeyPress(.escape, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Escape")
        XCTAssertFalse(result)
    }

    // MARK: - Arrow Key Tests

    func testUpArrowKey() throws {
        let result = viewModel.handleKeyPress(.upArrow, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Up")
        XCTAssertFalse(result)
    }

    func testDownArrowKey() throws {
        let result = viewModel.handleKeyPress(.downArrow, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Down")
        XCTAssertFalse(result)
    }

    func testLeftArrowKey() throws {
        let result = viewModel.handleKeyPress(.leftArrow, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Left")
        XCTAssertFalse(result)
    }

    func testRightArrowKey() throws {
        let result = viewModel.handleKeyPress(.rightArrow, modifiers: [])

        XCTAssertEqual(viewModel.lastKeyPress, "Right")
        XCTAssertFalse(result)
    }

    // MARK: - Command Shortcut Tests

    func testCommandN() throws {
        let result = viewModel.handleKeyPress("n", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+N")
        XCTAssertTrue(result)
    }

    func testCommandS() throws {
        let result = viewModel.handleKeyPress("s", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+S")
        XCTAssertTrue(result)
    }

    func testCommandZ() throws {
        let result = viewModel.handleKeyPress("z", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+Z")
        XCTAssertTrue(result)
    }

    func testCommandShiftZ() throws {
        let result = viewModel.handleKeyPress("z", modifiers: [.command, .shift])

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+Shift+Z")
        XCTAssertTrue(result)
    }

    func testCommandD() throws {
        let result = viewModel.handleKeyPress("d", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+D")
        XCTAssertTrue(result)
    }

    func testCommandF() throws {
        let result = viewModel.handleKeyPress("f", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+F")
        XCTAssertTrue(result)
    }

    func testCommand0() throws {
        let result = viewModel.handleKeyPress("0", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+0")
        XCTAssertTrue(result)
    }

    // MARK: - Zoom Shortcut Tests

    func testCommandPlus() throws {
        let result = viewModel.handleKeyPress("=", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd++")
        XCTAssertTrue(result)
    }

    func testCommandPlusWithPlusKey() throws {
        let result = viewModel.handleKeyPress("+", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd++")
        XCTAssertTrue(result)
    }

    func testCommandMinus() throws {
        let result = viewModel.handleKeyPress("-", modifiers: .command)

        XCTAssertEqual(viewModel.lastKeyPress, "Cmd+-")
        XCTAssertTrue(result)
    }

    // MARK: - Command Mode Tests

    func testIsCommandMode() throws {
        XCTAssertFalse(viewModel.isCommandMode)

        viewModel.isCommandMode = true

        XCTAssertTrue(viewModel.isCommandMode)
    }

    // MARK: - Default Key Handling Tests

    func testUnhandledKeyReturnsFalse() throws {
        let result = viewModel.handleKeyPress("a", modifiers: [])

        // The result should be false for unhandled keys
        XCTAssertFalse(result)
    }

    // MARK: - Notification Tests

    func testCommandNPostsNotification() throws {
        var notificationReceived = false

        let observer = NotificationCenter.default.addObserver(
            forName: .createNewMindMap,
            object: nil,
            queue: .main
        ) { _ in
            notificationReceived = true
        }

        _ = viewModel.handleKeyPress("n", modifiers: .command)

        XCTAssertTrue(notificationReceived)

        NotificationCenter.default.removeObserver(observer)
    }

    func testCommandSPostsNotification() throws {
        var notificationReceived = false

        let observer = NotificationCenter.default.addObserver(
            forName: .saveMindMap,
            object: nil,
            queue: .main
        ) { _ in
            notificationReceived = true
        }

        _ = viewModel.handleKeyPress("s", modifiers: .command)

        XCTAssertTrue(notificationReceived)

        NotificationCenter.default.removeObserver(observer)
    }

    func testCommandZPostsUndoNotification() throws {
        var notificationReceived = false

        let observer = NotificationCenter.default.addObserver(
            forName: .undoAction,
            object: nil,
            queue: .main
        ) { _ in
            notificationReceived = true
        }

        _ = viewModel.handleKeyPress("z", modifiers: .command)

        XCTAssertTrue(notificationReceived)

        NotificationCenter.default.removeObserver(observer)
    }

    func testCommandShiftZPostsRedoNotification() throws {
        var notificationReceived = false

        let observer = NotificationCenter.default.addObserver(
            forName: .redoAction,
            object: nil,
            queue: .main
        ) { _ in
            notificationReceived = true
        }

        _ = viewModel.handleKeyPress("z", modifiers: [.command, .shift])

        XCTAssertTrue(notificationReceived)

        NotificationCenter.default.removeObserver(observer)
    }

    func testCommandFPostsSearchNotification() throws {
        var notificationReceived = false

        let observer = NotificationCenter.default.addObserver(
            forName: .showSearch,
            object: nil,
            queue: .main
        ) { _ in
            notificationReceived = true
        }

        _ = viewModel.handleKeyPress("f", modifiers: .command)

        XCTAssertTrue(notificationReceived)

        NotificationCenter.default.removeObserver(observer)
    }
}
