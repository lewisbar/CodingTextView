//
//  FormattingHelperTests.swift
//  CodingTextView
//
//  Created by Lennart Wisbar on 12.05.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

//  MARK: Test Naming Rule
//  TEST_ACTION_EXPECTATION(_CONDITION)

import XCTest
@testable import CodingTextView

class FormattingHelperUnitTests: XCTestCase {
    
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
            return -textView.offset(from: cursorPosition!, to: textView.endOfDocument)
        }
        set {
            let position = textView.position(from: textView.endOfDocument, offset: newValue)
            XCTAssertNotNil(position)
            let range = textView.textRange(from: position!, to: position!)
            textView.selectedTextRange = range
        }
    }
    
    // MARK: - Normal Characters
    func test_NormalCharacters_NotAffected() {
        textView.text = "Hello"
        cursorOffsetFromEnd = -1    // Before the "o"
        textView.insertAsCode("a")
        
        XCTAssertEqual(textView.text, "Hellao")     // "a" after "Hell"
        XCTAssertEqual(cursorOffsetFromEnd, -1)     // after the typed "a"
    }
    
    // MARK: - Colon
    func test_ColonAfterCase_AdoptsSwitchIndentation() {
        textView.text = "\t\tswitch test {" +
                        "\n\t\t\tcase" +
                        "\n\t\t}"
        cursorOffsetFromEnd = -4    // After the open curly brace
        textView.insertAsCode(":")
        
        XCTAssertEqual(textView.text,
                        "\t\tswitch test {" +
                        "\n\t\tcase:" +     // Colon after "case", one tab removed
                        "\n\t\t}")
        XCTAssertEqual(cursorOffsetFromEnd, -4) // after the typed colon
    }
    
    func test_ColonAfterDefault_AdoptsSwitchIndentation() {
        textView.text = "\t\tswitch test {" +
                        "\n\t\t\tdefault" +
                        "\n\t\t}"
        cursorOffsetFromEnd = -4    // After the open curly brace
        textView.insertAsCode(":")
        
        XCTAssertEqual(textView.text,
                        "\t\tswitch test {" +
                        "\n\t\tdefault:" +     // Colon after "default", one tab removed
                        "\n\t\t}")
        XCTAssertEqual(cursorOffsetFromEnd, -4) // After the typed colon
    }
    
    func test_ColonAfterCase_TreatedNormally_IfNoSwitch() {
        textView.text = "\t\t\tcase"
        cursorOffsetFromEnd = 0
        textView.insertAsCode(":")
        
        XCTAssertEqual(textView.text, "\t\t\tcase:")    // No tabs removed
        XCTAssertEqual(cursorOffsetFromEnd, 0)
    }
    
    func test_Colon_TreatedNormally_IfNoCaseOrDefault() {
        textView.text = "\t\t\tnormalText"
        cursorOffsetFromEnd = 0
        textView.insertAsCode(":")
        
        XCTAssertEqual(textView.text,
                       "\t\t\tnormalText:")    // No tabs removed
        XCTAssertEqual(cursorOffsetFromEnd, 0)
    }
    
    // MARK: - Return Key
    func test_ReturnKeyAfterNormalCharacter_MaintainsIndentation() {
        textView.text = "\t\tnormalText"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\tnormalText" +
                        "\n\t\t")     // Indentation level maintained
        XCTAssertEqual(cursorOffsetFromEnd, 0)
    }
    
    func test_ReturnKeyAfterCurlyBrace_IndentsNextLineAndClosesBrace() {
        textView.text = "\t\ttest {"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\ttest {" +
                        "\n\t\t\t" +    // Indentation level maintained
                        "\n\t\t}")     // Closed curly brace added
        XCTAssertEqual(cursorOffsetFromEnd, -4) // End of the middle line
    }
    
    func test_ReturnKeyBetweenCurlyBraces_UsesExistingBrace() {
        textView.text = "\t\ttest {}"
        cursorOffsetFromEnd = -1    // Between the {}
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\ttest {" +
                        "\n\t\t\t" +    // Indentation level maintained
                        "\n\t\t}")      // No curly brace added
        XCTAssertEqual(cursorOffsetFromEnd, -4) // End of the middle line
    }
    
    func test_ReturnKeyAfterCurlyBrace_DoesNotAddAnotherBrace_IfTooManyClosedBraces() {
        textView.text = "test {" +
                        "\nanother line }"
        cursorOffsetFromEnd = -15   // After the open curly brace
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "test {" +
                        "\n\t" +    // Indentation works as normal after "{"
                        "\nanother line }") // No extra "}" added
        XCTAssertEqual(cursorOffsetFromEnd, -15)    // End of the middle line
    }
    
    func test_ReturnKeyAfterSwitchWithCurlyBrace_MaintainsIndentationAndClosesBrace() {
        textView.text = "\t\tswitch test {"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\tswitch test {" +
                        "\n\t\t" +    // Indentation level maintained
                        "\n\t\t}")     // Closed curly brace added
        XCTAssertEqual(cursorOffsetFromEnd, -4) // End of the middle line
    }
    
    func test_ReturnKeyAfterCaseWithColon_IndentsNextLine() {
        textView.text = "\t\tcase test:"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\tcase test:" +
                        "\n\t\t\t")     // Indentation level raised
        XCTAssertEqual(cursorOffsetFromEnd, 0) // End of new line
    }
    
    func test_ReturnKeyAfterCaseWithColonAndSpaces_IndentsNextLine() {
        textView.text = "\t\tcase test:   "
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\tcase test:   " +
                        "\n\t\t\t")     // Indentation level raised
        XCTAssertEqual(cursorOffsetFromEnd, 0) // End of new line
    }
    
    func test_ReturnKeyAfterCaseWithoutColon_DoesNotIndentNextLine() {
        textView.text = "\t\tcase test"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("\n")
        
        XCTAssertEqual(textView.text,
                        "\t\tcase test" +
                        "\n\t\t")     // Indentation level maintained
        XCTAssertEqual(cursorOffsetFromEnd, 0) // End of new line
    }
    
    // MARK: - Open Brackets
    func test_openRoundBracket_ProducesClosedBracket() {
        textView.text = "test"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("(")
        
        XCTAssertEqual(textView.text, "test()") // Bracket closed
        XCTAssertEqual(cursorOffsetFromEnd, -1) // Between the brackets
    }
    
    func test_openSquareBracket_ProducesClosedBracket() {
        textView.text = "test"
        cursorOffsetFromEnd = 0
        textView.insertAsCode("[")
        
        XCTAssertEqual(textView.text, "test[]") // Bracket closed
        XCTAssertEqual(cursorOffsetFromEnd, -1) // Between the brackets
    }
    
    func test_openRoundBracket_DoesNotProduceClosedBracket_IfTooManyClosedBrackets() {
        textView.text = "bracket test)"
        cursorOffsetFromEnd = -5    // Before "test"
        textView.insertAsCode("(")
        
        XCTAssertEqual(textView.text, "bracket (test)") // No additional bracket
        XCTAssertEqual(cursorOffsetFromEnd, -5) // After the open bracket
    }
    
    func test_openSquareBracket_DoesNotProduceClosedBracket_IfTooManyClosedBrackets() {
        textView.text = "bracket test]"
        cursorOffsetFromEnd = -5    // Before "test"
        textView.insertAsCode("[")
        
        XCTAssertEqual(textView.text, "bracket [test]") // No additional bracket
        XCTAssertEqual(cursorOffsetFromEnd, -5) // After the open bracket
    }
    
    
}
