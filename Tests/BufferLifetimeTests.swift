// BufferLifetimeTests.swift
//
// libxml2 must read the input while the input storage is alive.
// In optimized builds, the initializers released the storage too early,
// and the parser read freed memory. The result was random text.
// Debug builds do not show the problem. To find a regression, run:
//
//   swift test -c release --sanitize address

import XCTest
import Fuzi

class BufferLifetimeTests: XCTestCase {
  // This 198-byte description showed as random text in an optimized iOS build.
  let text = "No over caffeinated hosts. No discussion about Golden Eye. No complaining about government. No awkward boring discussion with sudden stops. Just the awesome Synth Music you love to listen to."

  func testHTMLDocumentFromString() throws {
    let document = try HTMLDocument(string: "<p>\(text)</p>")
    XCTAssertEqual(document.root?.stringValue, text)
  }

  func testHTMLDocumentFromCChars() throws {
    let cChars = try XCTUnwrap("<p>\(text)</p>".cString(using: .utf8))
    let document = try HTMLDocument(cChars: cChars)
    XCTAssertEqual(document.root?.stringValue, text)
  }

  func testHTMLDocumentFromData() throws {
    let document = try HTMLDocument(data: Data("<p>\(text)</p>".utf8))
    XCTAssertEqual(document.root?.stringValue, text)
  }

  func testXMLDocumentFromString() throws {
    let document = try XMLDocument(string: "<root>\(text)</root>")
    XCTAssertEqual(document.root?.stringValue, text)
  }

  func testXMLDocumentFromData() throws {
    let document = try XMLDocument(data: Data("<root>\(text)</root>".utf8))
    XCTAssertEqual(document.root?.stringValue, text)
  }
}
