import XCTest
@testable import myMindMap

final class ThemeTests: XCTestCase {

    // MARK: - Initialization Tests

    func testThemeInitialization() throws {
        let theme = Theme(
            name: "Custom Theme",
            backgroundColorHex: "#FFFFFF",
            nodeBackgroundColorHex: "#F0F0F0",
            nodeTextColorHex: "#000000",
            connectionColorHex: "#888888",
            isDarkMode: false,
            isDefault: false
        )

        XCTAssertNotNil(theme.id)
        XCTAssertEqual(theme.name, "Custom Theme")
        XCTAssertEqual(theme.backgroundColorHex, "#FFFFFF")
        XCTAssertEqual(theme.nodeBackgroundColorHex, "#F0F0F0")
        XCTAssertEqual(theme.nodeTextColorHex, "#000000")
        XCTAssertEqual(theme.connectionColorHex, "#888888")
        XCTAssertFalse(theme.isDarkMode)
        XCTAssertFalse(theme.isDefault)
    }

    // MARK: - Default Theme Tests

    func testDefaultLightTheme() throws {
        let theme = Theme.defaultLight

        XCTAssertEqual(theme.name, "Light")
        XCTAssertEqual(theme.backgroundColorHex, "#FFFFFF")
        XCTAssertEqual(theme.nodeBackgroundColorHex, "#F5F5F5")
        XCTAssertEqual(theme.nodeTextColorHex, "#000000")
        XCTAssertEqual(theme.connectionColorHex, "#888888")
        XCTAssertFalse(theme.isDarkMode)
        XCTAssertTrue(theme.isDefault)
    }

    func testDefaultDarkTheme() throws {
        let theme = Theme.defaultDark

        XCTAssertEqual(theme.name, "Dark")
        XCTAssertEqual(theme.backgroundColorHex, "#1E1E1E")
        XCTAssertEqual(theme.nodeBackgroundColorHex, "#2D2D2D")
        XCTAssertEqual(theme.nodeTextColorHex, "#FFFFFF")
        XCTAssertEqual(theme.connectionColorHex, "#666666")
        XCTAssertTrue(theme.isDarkMode)
        XCTAssertTrue(theme.isDefault)
    }

    // MARK: - Theme Properties Tests

    func testThemeDarkModeProperty() throws {
        let lightTheme = Theme.defaultLight
        let darkTheme = Theme.defaultDark

        XCTAssertFalse(lightTheme.isDarkMode)
        XCTAssertTrue(darkTheme.isDarkMode)
    }

    func testThemeIsDefaultProperty() throws {
        let defaultTheme = Theme.defaultLight
        let customTheme = Theme(
            name: "Custom",
            backgroundColorHex: "#000000",
            nodeBackgroundColorHex: "#111111",
            nodeTextColorHex: "#FFFFFF",
            connectionColorHex: "#AAAAAA",
            isDarkMode: true,
            isDefault: false
        )

        XCTAssertTrue(defaultTheme.isDefault)
        XCTAssertFalse(customTheme.isDefault)
    }

    func testThemeMindMapAssociation() throws {
        let theme = Theme.defaultLight
        let mindMap = MindMap(title: "Test Map")

        theme.mindMap = mindMap

        XCTAssertEqual(theme.mindMap?.id, mindMap.id)
    }

    // MARK: - Equatable Tests

    func testThemeEquality() throws {
        // Note: Due to auto-generated UUID id, themes with same properties are not equal
        // This test verifies that the Equatable conformance exists and works
        let theme1 = Theme.defaultLight
        let theme2 = theme1

        // Same instance should be equal
        XCTAssertEqual(theme1, theme2)
    }

    func testThemeInequality() throws {
        let theme1 = Theme.defaultLight
        let theme2 = Theme.defaultDark

        XCTAssertNotEqual(theme1, theme2)
    }

    // MARK: - Color Values Tests

    func testLightThemeColors() throws {
        let theme = Theme.defaultLight

        // Verify all color properties are valid hex strings
        XCTAssertTrue(theme.backgroundColorHex.hasPrefix("#"))
        XCTAssertTrue(theme.nodeBackgroundColorHex.hasPrefix("#"))
        XCTAssertTrue(theme.nodeTextColorHex.hasPrefix("#"))
        XCTAssertTrue(theme.connectionColorHex.hasPrefix("#"))
    }

    func testDarkThemeColors() throws {
        let theme = Theme.defaultDark

        // Verify all color properties are valid hex strings
        XCTAssertTrue(theme.backgroundColorHex.hasPrefix("#"))
        XCTAssertTrue(theme.nodeBackgroundColorHex.hasPrefix("#"))
        XCTAssertTrue(theme.nodeTextColorHex.hasPrefix("#"))
        XCTAssertTrue(theme.connectionColorHex.hasPrefix("#"))
    }
}
