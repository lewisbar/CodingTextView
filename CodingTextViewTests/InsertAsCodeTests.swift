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
    
    func moveCursorToEnd(offset: Int = 0) {
        let position = textView.position(from: textView.endOfDocument, offset: offset)
        XCTAssertNotNil(position)
        let range = textView.textRange(from: position!, to: position!)
        textView.selectedTextRange = range
    }
    
    func testNormalCharactersNotAffected() {
        textView.text = "Hello"
        moveCursorToEnd(offset: -1)
        textView.insertAsCode("a")
        XCTAssertEqual(textView.text, "Hellao")     // "a" after "Hell"
    }
    
    func testColonGivesCaseSwitchIndentation() {
        textView.text = "Line 1\n" +
            "\t\tswitch test {\n" +
            "\t\t\tcase\n" +
        "\t\t}"
        moveCursorToEnd(offset: -4)
        textView.insertAsCode(":")
        XCTAssertEqual(textView.text, "Line 1\n" +
            "\t\tswitch test {\n" +
            "\t\tcase:\n" +     // Colon after "case", one tab removed
            "\t\t}")
    }
}
