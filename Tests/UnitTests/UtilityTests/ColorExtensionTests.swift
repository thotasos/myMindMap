import XCTest
import SwiftUI
import AppKit
@testable import myMindMap

final class ColorExtensionTests: XCTestCase {

    // MARK: - Hex Initialization Tests

    func testColorInitWithValid6DigitHex() throws {
        let color = Color(hex: "#FF5733")

        XCTAssertNotNil(color)
    }

    func testColorInitWithValid6DigitHexWithoutHash() throws {
        let color = Color(hex: "FF5733")

        XCTAssertNotNil(color)
    }

    func testColorInitWithValid8DigitHex() throws {
        let color = Color(hex: "#FF5733FF")

        XCTAssertNotNil(color)
    }

    func testColorInitWithInvalidHex() throws {
        let color = Color(hex: "invalid")

        XCTAssertNil(color)
    }

    func testColorInitWithEmptyString() throws {
        let color = Color(hex: "")

        XCTAssertNil(color)
    }

    func testColorInitWithWrongLengthHex() throws {
        let color = Color(hex: "#FF")

        XCTAssertNil(color)
    }

    // MARK: - White and Black Tests

    func testWhiteColor() throws {
        let color = Color(hex: "#FFFFFF")

        XCTAssertNotNil(color)
    }

    func testBlackColor() throws {
        let color = Color(hex: "#000000")

        XCTAssertNotNil(color)
    }

    // MARK: - To Hex Conversion Tests

    func testToHexWithoutAlpha() throws {
        guard let color = Color(hex: "#FF5733") else {
            XCTFail("Failed to create color")
            return
        }

        let hex = color.toHex()

        XCTAssertNotNil(hex)
        XCTAssertTrue(hex?.hasPrefix("#") ?? false)
    }

    func testToHexWithAlpha() throws {
        guard let color = Color(hex: "#FF5733FF") else {
            XCTFail("Failed to create color")
            return
        }

        let hex = color.toHex(includeAlpha: true)

        XCTAssertNotNil(hex)
        XCTAssertEqual(hex?.count, 9) // #RRGGBBAA
    }

    // MARK: - NSColor Extension Tests

    func testNSColorInitWithValidHex() throws {
        let color = NSColor(hex: "#FF5733")

        XCTAssertNotNil(color)
    }

    func testNSColorInitWithInvalidHex() throws {
        let color = NSColor(hex: "invalid")

        XCTAssertNil(color)
    }

    func testNSColorInitWith6DigitHex() throws {
        let color = NSColor(hex: "FF5733")

        XCTAssertNotNil(color)
    }

    func testNSColorInitWith8DigitHex() throws {
        let color = NSColor(hex: "FF5733FF")

        XCTAssertNotNil(color)
    }

    func testNSColorInitWithWrongLength() throws {
        let color = NSColor(hex: "#FF5")

        XCTAssertNil(color)
    }

    // MARK: - Edge Cases

    func testColorInitWithMixedCase() throws {
        let colorLower = Color(hex: "#ff5733")
        let colorUpper = Color(hex: "#FF5733")
        let colorMixed = Color(hex: "#Ff5733")

        XCTAssertNotNil(colorLower)
        XCTAssertNotNil(colorUpper)
        XCTAssertNotNil(colorMixed)
    }

    func testColorInitWithWhitespace() throws {
        let color = Color(hex: "  #FF5733  ")

        XCTAssertNotNil(color)
    }

    func testColorInitWithLeadingZeros() throws {
        let color = Color(hex: "#0000FF")

        XCTAssertNotNil(color)
    }
}
