//
//  InsertAsCodeTests.swift
//  CodingTextView
//
//  Created by Lennart Wisbar on 12.05.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import XCTest
@testable import CodingTextView

class InsertAsCodeUnitTests: XCTestCase {
    
    let textView = UITextView()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Helper Section
    var cursorOffsetFromEnd: Int {
        get {
            let cursorPosition = textView.selectedTextRange?.start
            XCTAssertNotNil(cursorPosition)
            return textView.offset(from: cursorPosition!, to: textView.endOfDocument)
        }
        set {
            let position = textView.position(from: textView.endOfDocument, offset: newValue)
            XCTAssertNotNil(position)
            let range = textView.textRange(from: position!, to: position!)
            textView.selectedTextRange = range
        }
    }
    
    // MARK: - Normal Characters
    func testNormalCharactersNotAffected() {
        textView.text = "Hello"
        cursorOffsetFromEnd = -1
        textView.insertAsCode("a")
        XCTAssertEqual(textView.text, "Hellao")     // "a" after "Hell"
    }
    
    // MARK: - Colon
    func testColonGivesCaseIndentationOfLastSwitch() {
        textView.text = "Line 1\n" +
                        "\t\tswitch test {\n" +
                        "\t\t\tcase\n" +
                        "\t\t}"
        cursorOffsetFromEnd = -4
        textView.insertAsCode(":")
        XCTAssertEqual(textView.text,
                       "Line 1\n" +
                        "\t\tswitch test {\n" +
                        "\t\tcase:\n" +     // Colon after "case", one tab removed
                        "\t\t}")
    }
    
    func testColonGivesDefaultIndentationOfLastSwitch() {
        textView.text = "Line 1\n" +
                        "\t\tswitch test {\n" +
                        "\t\t\tdefault\n" +
                        "\t\t}"
        cursorOffsetFromEnd = -4
        textView.insertAsCode(":")
        XCTAssertEqual(textView.text,
                       "Line 1\n" +
                        "\t\tswitch test {\n" +
                        "\t\tdefault:\n" +     // Colon after "default", one tab removed
                        "\t\t}")
    }
    
    func testColonTreatedNormallyIfNoSwitch() {
        textView.text = "Line 1\n" +
                        "\t\t\tcase\n" +
                        "\t\t}"
        cursorOffsetFromEnd = -4
        textView.insertAsCode(":")
        XCTAssertEqual(textView.text,
                       "Line 1\n" +
                        "\t\t\tcase:\n" +     // Colon after "case", no tabs removed
                        "\t\t}")
    }
    
    func testColonTreatedNormallyIfNoCaseOrDefault() {
        textView.text = "Line 1\n" +
                        "\t\t\tnormalText"
        cursorOffsetFromEnd = 0
        textView.insertAsCode(":")
        XCTAssertEqual(textView.text,
                       "Line 1\n" +
                        "\t\t\tnormalText:")    // Colon after "normalText", no tabs removed
    }
    
    // MARK: - Return Key
    func testReturnKeyMaintainsIndentationAfterNormalCharacter() {
        textView.text = "Line 1\n" +
                        "\t\tnormalText"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        XCTAssertEqual(textView.text,
                       "Line 1\n" +
                        "\t\tnormalText\n" +
                        "\t\t")     // Indentation level maintained
    }
    
    func testReturnKeyAfterSwitchWithCurlyBraceMaintainsIndentationAndClosesBrace() {
        textView.text = "Line 1\n" +
                        "\t\tswitch test {"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        XCTAssertEqual(textView.text,
                       "Line 1\n" +
                        "\t\tswitch test {\n" +
                        "\t\t\n" +    // Indentation level maintained
                        "\t\t}")     // Closed curly brace added
    }
    
    //TODO: Evalutate cursor position at the end of every test func
}
