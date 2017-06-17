//
//  FormattingHelperTests.swift
//  CodingTextView
//
//  Created by Lennart Wisbar on 12.05.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import XCTest
@testable import CodingTextView

class FormattingHelperTests: XCTestCase {
    
    // TODO: Probably all tests need a version with whitespace, meaning they should still work if a space or - in some cases - tab is in between the relevant parts of the string
    // MARK: - Normal Text
    func test_NormalCharacter_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(3, 0) // "t"
        
        let insertion = "a"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "tesat"
        let expectedRange = NSMakeRange(4, 0) // "t"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalCharacter_AtTheEnd_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(4, 0) // End
        
        let insertion = "a"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "testa"
        let expectedRange = NSMakeRange(5, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalCharacter_AtTheBeginning_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(0, 0) // Beginning
        
        let insertion = "a"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "atest"
        let expectedRange = NSMakeRange(1, 0) // After the "a"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalCharacter_InTheMiddleOfWhitespace_InsertedNormally() {
        let text = "tes\t  \tt"
        let range = NSMakeRange(5, 0) // After the first space
        
        let insertion = "a"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "tes\t a \tt"
        let expectedRange = NSMakeRange(6, 0) // After the "a"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(3, 0) // "t"

        let insertion = "abc"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "tesabct"
        let expectedRange = NSMakeRange(6, 0) // "t"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_AtTheBeginning_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(0, 0) // Beginning
        
        let insertion = "abc"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "abctest"
        let expectedRange = NSMakeRange(3, 0) // After "abc"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_AtTheEnd_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(4, 0) // End
        
        let insertion = "abc"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "testabc"
        let expectedRange = NSMakeRange(7, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_InTheMiddleOfWhitespace_InsertedNormally() {
        let text = "tes\t  \tt"
        let range = NSMakeRange(5, 0) // Between the spaces
        
        let insertion = "abc"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "tes\t abc \tt"
        let expectedRange = NSMakeRange(8, 0) // After "abc"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_ReplacesSelection() {
        let text = "test abc test"
        let range = NSMakeRange(4, 4) // " abc"
        
        let insertion = "er"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "tester test"
        let expectedRange = NSMakeRange(6, 0) // After "tester"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_AtTheBeginning_ReplacesSelection() {
        let text = "abc test test"
        let range = NSMakeRange(0, 4) // "abc "
        
        let insertion = "..."
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "...test test"
        let expectedRange = NSMakeRange(3, 0) // After "..."
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_AtTheEnd_ReplacesSelection() {
        let text = "test test abc"
        let range = NSMakeRange(9, 4) // " abc"
        
        let insertion = "er"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test tester"
        let expectedRange = NSMakeRange(11, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_InTheMiddleOfWhitespace_ReplacesSelection() {
        let text = "test\t  abc  \ttest"
        let range = NSMakeRange(6, 5) // " abc "
        
        let insertion = "..."
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test\t ... \ttest"
        let expectedRange = NSMakeRange(9, 0) // After "..."
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_ReplacesSelection_AcrossMultipleLines() {
        let text =
            "test" + "\n" +
            "abc" + "\n" +
            "abc test"
        let range = NSMakeRange(4, 8) // "\nabc\nabc"
        
        let insertion = "er"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "tester test"
        let expectedRange = NSMakeRange(6, 0) // After "tester"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    // MARK: - Backspace
    func test_Backspace_DeletesPreviousCharacter() {
        let text = "test abc"
        let range = NSMakeRange(5, 1)   // "a"
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test bc"
        let expectedRange = NSMakeRange(5, 0)   // Before "b"
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_AtStartOfLine_DeletesNewLine() {
        let text =
            "test " + "\n" +
            "abc"
        let range = NSMakeRange(5, 1)   // "\n"
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "test abc"
        let expectedRange = NSMakeRange(5, 0)   // After the space
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_AtTheEnd_DeletesPreviousCharacter() {
        let text = "test abc"
        let range = NSMakeRange(7, 1)   // "c"
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test ab"
        let expectedRange = NSMakeRange(7, 0)   // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_InTheMiddleOfWhitespace_DeletesPreviousWhitespace() {
        let text = "test \t  \tabc"
        let range = NSMakeRange(6, 1)   // Whitespace after first tab
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test \t \tabc"
        let expectedRange = NSMakeRange(6, 0)   // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_WhileTextIsSelected_DeletesSelectedText() {
        let text = "test abc"
        let range = NSMakeRange(5, 2)   // "ab"
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test c"
        let expectedRange = NSMakeRange(5, 0)   // Before "c"
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_WhileTextIsSelected_AtTheBeginning_DeletesSelectedText() {
        let text = "abc test"
        let range = NSMakeRange(0, 4)   // "abc "
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test"
        let expectedRange = NSMakeRange(0, 0)   // Beginning
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_WhileTextIsSelected_AtTheEnd_DeletesSelectedText() {
        let text = "test abc"
        let range = NSMakeRange(4, 4)   // " abc"
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test"
        let expectedRange = NSMakeRange(4, 0)   // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_WhileTextIsSelected_InTheMiddleOfWhitespace_DeletesSelectedText() {
        let text = "test\t  abc \ttest"
        let range = NSMakeRange(6, 5)   // " abc "
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test\t \ttest"
        let expectedRange = NSMakeRange(6, 0)   // Before the second tab
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_Backspace_WhileTextIsSelected_AcrossMultipleLines_DeletesSelectedText() {
        let text =
            "test abc" + "\n" +
            "abc test"
        let range = NSMakeRange(5, 8)   // "abc\nabc "
        let insertion = ""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "test test"
        let expectedRange = NSMakeRange(5, 0)   // After the space
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    // MARK: - New Line
    func test_NewLine_MaintainsIndentation() {
        let text =
            "\t\t" + "test"
        let range = NSMakeRange(5, 0) // "t"
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "tes" + "\n" +
            "\t\tt"
        let expectedRange = NSMakeRange(8, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AtBeginningOfLine_MaintainsIndentation() {
        let text =
            "\t\t" + "test"
        let range = NSMakeRange(2, 0) // After the tabs
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "\n" +
            "\t\t" + "test"
        let expectedRange = NSMakeRange(5, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AtTheEnd_MaintainsIndentation() {
        let text =
            "\t\t" + "test"
        let range = NSMakeRange(6, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(9, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_InTheMiddleOfWhitespace_MaintainsIndentation() {
        let text =
            "\t\t" + "test\t  \t"
        let range = NSMakeRange(8, 0) // In the middle of the spaces
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test\t " + "\n" +
            "\t\t" + " \t"
        let expectedRange = NSMakeRange(11, 0) // After the two tabs in the second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_IndentsAndAddsClosedBrace() {
        let text =
            "\t\t" + "test {abc"
        let range = NSMakeRange(8, 0) // Before "abc"
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}abc"
        let expectedRange = NSMakeRange(12, 0) // After the tabs in the second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_AtTheBeginning_IndentsAndAddsClosedBrace() {
        let text =
            "{abc"
        let range = NSMakeRange(1, 0) // Before "abc"
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "{" + "\n" +
            "\t" + "\n" +
            "}abc"
        let expectedRange = NSMakeRange(3, 0) // After the tab in the second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_AtTheEnd_IndentsAndAddsClosedBrace() {
        let text =
            "\t\t" + "test {"
        let range = NSMakeRange(8, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(12, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_InTheMiddleOfWhitespace_IndentsAndAddsClosedBrace() {
        let text =
            "\t\t" + "test {\t  \t"
        let range = NSMakeRange(10, 0) // In the middle of the whitespace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {\t " + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "} \t"
        let expectedRange = NSMakeRange(14, 0) // After the tabs in the second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_BetweenCurlyBraces_UsesExistingBrace() {
        let text = "\t\t" + "test {}"
        let range = NSMakeRange(8, 0) // Closed brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(12, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_BetweenCurlyBraces_InTheMiddleOfWhitespace_UsesExistingBrace() {
        let text =
            "\t\t" + "test {\t  \t}"
        let range = NSMakeRange(10, 0) // Middle of whitespace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {\t " + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + " \t}" // TODO: Is this how this strange case should be handled? It's just what happens.
        let expectedRange = NSMakeRange(14, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_BetweenCurlyBraces_AfterWhitespace_UsesExistingBrace() {
        let text =
            "\t\t" + "test {\t }"
        let range = NSMakeRange(10, 0) // Closed brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {\t " + "\n" +
                "\t\t\t" + "\n" +
                "\t\t" + "}"
        let expectedRange = NSMakeRange(14, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_IndentsWithoutAddingClosedBrace_IfTooManyClosedBraces() {
        let text =
            "\t\t" + "test {" + "\n" +
            "another line }"
        let range = NSMakeRange(8, 0) // After open curly brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "another line }"
        let expectedRange = NSMakeRange(12, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_WithWhitespace_IndentsWithoutAddingClosedBrace_IfTooManyClosedBraces() {
        let text =
            "\t\t" + "test {\t " + "\n" +
            "another line }"
        let range = NSMakeRange(10, 0) // End of first line
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {\t " + "\n" +
            "\t\t\t" + "\n" +
            "another line }"
        let expectedRange = NSMakeRange(14, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }

    func test_NewLine_AfterCurlyBraceAfterSwitch_AddsClosedBraceWithoutIndenting() {
        let text =
            "\t\t" + "switch test {"
        let range = NSMakeRange(15, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(18, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBraceAfterSwitch_WithWhiteSpace_AddsClosedBraceWithoutIndenting() {
        let text =
            "\t\t" + "switch test {\t "
        let range = NSMakeRange(17, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {\t " + "\n" +
                "\t\t" + "\n" +
                "\t\t" + "}"
        let expectedRange = NSMakeRange(20, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_BetweenCurlyBracesAfterSwitch_UsesExistingCurlyBraceWithoutIndenting() {
        let text =
            "\t\t" + "switch test {}"
        let range = NSMakeRange(15, 0) // Closed brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(18, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_BetweenCurlyBracesAfterSwitch_WithWhitespace_UsesExistingCurlyBraceWithoutIndenting() {
        let text =
            "\t\t" + "switch test {\t }"
        let range = NSMakeRange(17, 0) // Closed brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {\t " + "\n" +
            "\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(20, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBraceAfterSwitch_NoBraceOrIndentationAdded_IfTooManyClosedBraces() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "another line }"
        let range = NSMakeRange(15, 0) // After open curly brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "\n" +
            "another line }"
        let expectedRange = NSMakeRange(18, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBraceAfterSwitch_WithWhitespace_NoBraceOrIndentationAdded_IfTooManyClosedBraces() {
        let text =
            "\t\t" + "switch test {\t " + "\n" +
            "another line }"
        let range = NSMakeRange(17, 0) // After open curly brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {\t " + "\n" +
            "\t\t" + "\n" +
            "another line }"
        let expectedRange = NSMakeRange(20, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBraceAfterSwitchWithoutText_IgnoresSwitch() {
        let text =
            "\t\t" + "switch {"
        let range = NSMakeRange(10, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch {" + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(14, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBraceAfterSwitchWithoutText_WithWhitespace_IgnoresSwitch() {
        let text =
            "\t\t" + "switch {\t "
        let range = NSMakeRange(12, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch {\t " + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(16, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColon_NotIndented() {
        let text =
            "\t\t" + "test:"
        let range = NSMakeRange(7, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test:" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(10, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColon_WithWhitespace_NotIndented() {
        let text =
            "\t\t" + "test:\t "
        let range = NSMakeRange(9, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test:\t " + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(12, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCaseWithoutColon_NotIndented() {
        let text =
            "\t\t" + "case test"
        let range = NSMakeRange(11, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case test" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(14, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCaseWithoutColon_WithWhitespace_NotIndented() {
        let text =
            "\t\t" + "case test\t "
        let range = NSMakeRange(13, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case test\t " + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(16, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterDefaultWithoutColon_NotIndented() {
        let text =
            "\t\t" + "default"
        let range = NSMakeRange(9, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "default" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(12, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterDefaultWithoutColon_WithWhitespace_NotIndented() {
        let text =
            "\t\t" + "default\t "
        let range = NSMakeRange(11, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "default\t " + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(14, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColonAfterCase_Indents() {
        let text =
            "\t\t" + "case test:"
        let range = NSMakeRange(12, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case test:" + "\n" +
            "\t\t\t"
        let expectedRange = NSMakeRange(16, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColonAfterCase_WithWhitespace_Indents() {
        let text =
            "\t\t" + "case test:\t "
        let range = NSMakeRange(14, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case test:\t " + "\n" +
            "\t\t\t"
        let expectedRange = NSMakeRange(18, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColonAfterDefault_Indents() {
        let text =
            "\t\t" + "default:"
        let range = NSMakeRange(10, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "default:" + "\n" +
            "\t\t\t"
        let expectedRange = NSMakeRange(14, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColonAfterDefault_WithWhitespace_Indents() {
        let text =
            "\t\t" + "default:\t "
        let range = NSMakeRange(12, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "default:\t " + "\n" +
            "\t\t\t"
        let expectedRange = NSMakeRange(16, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterTextAfterColonAfterCase_NotIndented() {
        let text =
            "\t\t" + "case test: test"
        let range = NSMakeRange(17, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case test: test" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(20, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterTextAfterColonAfterCase_WithWhitespace_NotIndented() {
        let text =
            "\t\t" + "case test: test\t "
        let range = NSMakeRange(19, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case test: test\t " + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(22, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterTextAfterColonAfterDefault_NotIndented() {
        let text = "\t\t" + "default: test"
        let range = NSMakeRange(15, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "default: test" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(18, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColonAfterCaseWithoutText_NotIndented() {
        let text = "\t\t" + "case:"
        let range = NSMakeRange(7, 0) // After colon
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "case:" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(10, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterColonAfterDefaultWithText_NotIndented() {
        let text = "\t\t" + "default test:"
        let range = NSMakeRange(15, 0) // End
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "default test:" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(18, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    // MARK: - Colon
    func test_ColonWithoutCaseOrDefault_TreatedNormally() {
        let text = "\t\ttext"
        let range = NSMakeRange(6, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "\t\ttext:"
        let expectedRange = NSMakeRange(7, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonWithoutCaseOrDefault_WithSwitch_TreatedNormally() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "test"
        let range = NSMakeRange(24, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "test:"
        let expectedRange = NSMakeRange(25, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterCase_AdoptsSwitchIndentation() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "case test"
        let range = NSMakeRange(29, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "case test:"
        let expectedRange = NSMakeRange(28, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterDefault_AdoptsSwitchIndentation() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "default"
        let range = NSMakeRange(27, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "default:"
        let expectedRange = NSMakeRange(26, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterCase_WithTextInNextLine_AdoptsSwitchIndentation() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "case test" + "\n" +
            "\t\t}"
        let range = NSMakeRange(29, 0) // End of second line
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "case test:" + "\n" +
            "\t\t}"
        let expectedRange = NSMakeRange(28, 0) // End of second line
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterDefault_WithTextInNextLine_AdoptsSwitchIndentation() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "default" + "\n" +
            "\t\t}"
        let range = NSMakeRange(27, 0) // End of second line
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "default:" + "\n" +
            "\t\t}"
        let expectedRange = NSMakeRange(26, 0) // End of second line
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterCaseWithoutSwitch_TreatedNormally() {
        let text =
            "\t\t" + "test {" + "\n" +
            "\t\t\t\t" + "case test"
        let range = NSMakeRange(22, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t\t" + "case test:"
        let expectedRange = NSMakeRange(23, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterDefaultWithoutSwitch_TreatedNormally() {
        let text =
            "\t\t" + "test {" + "\n" +
            "\t\t\t\t" + "default"
        let range = NSMakeRange(20, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t\t" + "default:"
        let expectedRange = NSMakeRange(21, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterCaseWithoutText_TreatedNormally() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "case"
        let range = NSMakeRange(24, 0) // End
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "case:"
        let expectedRange = NSMakeRange(25, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ColonAfterCaseWithoutText_WithTextInNextLine_TreatedNormally() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "case" + "\n" +
            "\t\t}"
        let range = NSMakeRange(24, 0) // End of second line
        let insertion = ":"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t\t\t" + "case:" + "\n" +
            "\t\t}"
        let expectedRange = NSMakeRange(25, 0) // End of second line
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    // MARK: - Open Brackets
    func test_OpenRoundBracket_ProducesClosedBracket() {
        let text = "test"
        let range = NSMakeRange(4, 0)   // End
        let insertion = "("
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test()" // Bracket closed
        let expectedRange = NSMakeRange(5, 0) // Between the brackets
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_OpenSquareBracket_ProducesClosedBracket() {
        let text = "test"
        let range = NSMakeRange(4, 0)   // End
        let insertion = "["
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test[]" // Bracket closed
        let expectedRange = NSMakeRange(5, 0) // Between the brackets
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_OpenRoundBracket_DoesNotProduceClosedBracket_IfTooManyClosedBrackets() {
        let text = "test brackets)"
        let range = NSMakeRange(5, 0)   // Before "brackets"
        let insertion = "("
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test (brackets)" // No additional bracket
        let expectedRange = NSMakeRange(6, 0) // After the new bracket
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_OpenSquareBracket_DoesNotProduceClosedBracket_IfTooManyClosedBrackets() {
        let text = "test brackets]"
        let range = NSMakeRange(5, 0)   // Before "brackets"
        let insertion = "["
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test [brackets]" // No additional bracket
        let expectedRange = NSMakeRange(6, 0) // After the new bracket
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }

    // MARK: - Closed Round Brackets
    func test_ClosedRoundBracketAfterNormalCharacter_TreatedNormally() {
        let text = "(test"
        let range = NSMakeRange(5, 0)   // End
        let insertion = ")"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "(test)"
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ClosedRoundBracketBeforeClosedRoundBracket_StepsOver() {
        let text = "(test)"
        let range = NSMakeRange(5, 0)   // Before closed bracket
        let insertion = ")"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "(test)" // No bracket added
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }

    func test_ClosedRoundBracketBeforeClosedRoundBracket_TreatedNormally_IfMoreOpenBrackets() {
        let text = "(bracket (test)"
        let range = NSMakeRange(14, 0)   // Before closed bracket
        let insertion = ")"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "(bracket (test))" // No bracket added
        let expectedRange = NSMakeRange(15, 0) // Between the two closed brackets
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }

    // TODO: Play warning sound when too many closed round brackets in the document
    
    // MARK: - Closed Square Brackets
    func test_ClosedSquareBracketAfterNormalCharacter_TreatedNormally() {
        let text = "[test"
        let range = NSMakeRange(5, 0)   // End
        let insertion = "]"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "[test]"
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ClosedSquareBracketBeforeClosedSquareBracket_StepsOver() {
        let text = "[test]"
        let range = NSMakeRange(5, 0)   // Before closed bracket
        let insertion = "]"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "[test]" // No bracket added
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ClosedSquareBracketBeforeClosedSquareBracket_TreatedNormally_IfMoreOpenBrackets() {
        let text = "[bracket [test]"
        let range = NSMakeRange(14, 0)   // Before closed bracket
        let insertion = "]"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "[bracket [test]]" // No bracket added
        let expectedRange = NSMakeRange(15, 0) // Between the two closed brackets
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }

    // TODO: Play warning sound when too many closed square brackets in the document
    
    // MARK: - Closed Curly Braces
    func test_ClosedCurlyBraceAfterNormalCharacter_TreatedNormally() {
        let text = "{test"
        let range = NSMakeRange(5, 0)   // End
        let insertion = "}"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "{test}"
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ClosedCurlyBraceBeforeClosedCurlyBrace_StepsOver() {
        let text = "{test}"
        let range = NSMakeRange(5, 0)   // Before closed brace
        let insertion = "}"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "{test}" // No brace added
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_ClosedCurlyBraceBeforeClosedCurlyBrace_TreatedNormally_IfTooManyOpenBraces() {
        let text = "{brace {test}"
        let range = NSMakeRange(12, 0)   // Before closed bracket
        let insertion = "}"
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "{brace {test}}" // No brace added
        let expectedRange = NSMakeRange(13, 0) // Between the two closed brackets
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
   
    // TODO: Play warning sound when too many closed curly braces in the document
    
    // MARK: - Quotation Marks
    func test_QuotationMark_CompletedByAnotherOne() {
        let text = "test"
        let range = NSMakeRange(4, 0)   // End
        let insertion = "\""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "test\"\""   // Two quotation marks added
        let expectedRange = NSMakeRange(5, 0) // Between the quotes
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_QuotationMarkBeforeQuotationMark_StepsOver_IfEvenNumberOfQuotesInDocument() {
        let text = "\"test\""
        let range = NSMakeRange(5, 0)   // Before the second quotation mark
        let insertion = "\""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "\"test\"" // No quotation mark added
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_QuotationMark_TreatedNormally_IfUnevenNumberOfQuotesInDocument() {
        let text = "\"test"
        let range = NSMakeRange(5, 0)   // End
        let insertion = "\""
        let (newText, newRange) = FormattingHelper.formattedText(for: insertion, in: text, range: range)
        
        let expectedText = "\"test\"" // No additional quotation mark
        let expectedRange = NSMakeRange(6, 0) // End
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Helper Tests
    // Helper methods should be made private once they pass the test (or at least at some point in the future)
    // These tests must then be deleted or commented out
    // CompletedInput
    func test_CompletedInput_Normal() {
        let (insertion, offset) = FormattingHelper.completedInput(for: "abc", scenario: .normal, indentation: 2)
        let expectedInsertion = "abc"
        let expectedOffset = 3
        XCTAssertEqual(expectedInsertion, insertion)
        XCTAssertEqual(expectedOffset, offset)
    }
    
    func test_CompletedInput_NewLine() {
        let (insertion, offset) = FormattingHelper.completedInput(for: "\n", scenario: .newLine, indentation: 2)
        let expectedInsertion = "\n\t\t"
        let expectedOffset = 3
        XCTAssertEqual(expectedInsertion, insertion)
        XCTAssertEqual(expectedOffset, offset)
    }
    
    func test_CompletedInput_NewLineAfterCurlyBrace() {
        let (insertion, offset) = FormattingHelper.completedInput(for: "\n", scenario: .newLineAfterCurlyBrace, indentation: 2)
        let expectedInsertion = "\n\t\t\t\n\t\t}"
        let expectedOffset = 4
        XCTAssertEqual(expectedInsertion, insertion)
        XCTAssertEqual(expectedOffset, offset)
    }
    
    func test_CompletedInput_NewLineAfterCurlyBraceAlreadyClosed() {
        let (insertion, offset) = FormattingHelper.completedInput(for: "\n", scenario: .newLineAfterCurlyBraceAlreadyClosed, indentation: 2)
        let expectedInsertion = "\n\t\t\t"
        let expectedOffset = 4
        XCTAssertEqual(expectedInsertion, insertion)
        XCTAssertEqual(expectedOffset, offset)
    }
    
    // Other Helpers
    func test_StringRangeFromRange() {
        let text = "0123456789"
        let range = NSMakeRange(1, 2)   // 1 and 2
        guard let stringRange = text.stringRange(from: range) else {
            XCTFail("stringRange should not be nil")
            return
        }
        let selectedText = text.substring(with: stringRange)
        XCTAssertEqual(selectedText, "12")
    }
    
    func test_RangeOfClosestTextBeforePosition() {
        let text = "0123...4567...89...0"
        let position = text.index(text.startIndex, offsetBy: 15)  // Between 8 and 9
        
        let range = text.range(ofClosest: "...", before: position)
        
        let expectedStart = text.index(text.startIndex, offsetBy: 11)
        let expectedEnd = text.index(expectedStart, offsetBy: 3)
        
        XCTAssertEqual(range?.lowerBound, expectedStart)
        XCTAssertEqual(range?.upperBound, expectedEnd)
    }
    
    func test_RangeOfClosestTextAfterPosition() {
        let text = "0123...4567...89...0"
        let position = text.index(text.startIndex, offsetBy: 8)  // Between 4 and 5
        
        let range = text.range(ofClosest: "...", after: position)
        
        let expectedStart = text.index(text.startIndex, offsetBy: 11)
        let expectedEnd = text.index(expectedStart, offsetBy: 3)
        
        XCTAssertEqual(range?.lowerBound, expectedStart)
        XCTAssertEqual(range?.upperBound, expectedEnd)
    }
    
    func test_Tabs() {
        let tabs = String.tabs(for: 3)
        XCTAssertEqual(tabs, "\t\t\t")
    }
    
    func test_CharacterBefore() {
        let text = "ab c"
        let position = text.index(text.startIndex, offsetBy: 3)  // Before c
        let character = text.character(before: position, ignoring: [" "])
        let expectedCharacter: Character = "b"
        XCTAssertEqual(expectedCharacter, character!)
    }
    
    func test_CharacterBeforeStart_ReturnsNil() {
        let text = "abc"
        let character = text.character(before: text.startIndex)
        XCTAssertNil(character)
    }
    
    func test_CharacterAt() {
        let text = "ab c"
        let position = text.index(text.startIndex, offsetBy: 2)  // After b
        let character = text.character(at: position, ignoring: [" "])
        let expectedCharacter: Character = "c"
        XCTAssertEqual(expectedCharacter, character)
    }
    
    func test_CharacterAtEnd_ReturnsNil() {
        let text = "abc"
        let position = text.index(text.startIndex, offsetBy: 3)  // After c
        let character = text.character(at: position)
        XCTAssertNil(character)
    }
    
    func test_NumberOfStringInRange() {
        let text = "ab..cdef..ghi..jkl..mnop...qrs."
        let range = text.startIndex..<text.endIndex
        let number = text.number(of: "..", in: range)
        let expectedNumber = 5
        XCTAssertEqual(expectedNumber, number)
    }
    
    func test_RemovingIndentation() {
        let text =
            "\t" + "line 1" + "\n" +
            "\t\t\t" + "line 2"
        let line2Start = text.index(text.startIndex, offsetBy: 8)
        let line2Range = line2Start..<text.endIndex
        let newText = text.removingIndentation(of: line2Range)
        let expectedText =
            "\t" + "line 1" + "\n" +
            "line 2"
        XCTAssertEqual(newText, expectedText)
    }
    
    func test_SettingIndentationLevel_CanIncreaseIndentation() {
        let text =
            "\t" + "line 1" + "\n" +
            "\t" + "line 2"
        let line2Start = text.index(text.startIndex, offsetBy: 8)
        let line2Range = line2Start..<text.endIndex
        let newText = text.settingIndentationLevel(of: line2Range, to: 3)
        let expectedText =
            "\t" + "line 1" + "\n" +
            "\t\t\t" + "line 2"
        XCTAssertEqual(newText, expectedText)
    }
    
    func test_SettingIndentationLevel_CanDecreaseIndentation() {
        let text =
            "\t" + "line 1" + "\n" +
            "\t\t\t" + "line 2"
        let line2Start = text.index(text.startIndex, offsetBy: 8)
        let line2Range = line2Start..<text.endIndex
        let newText = text.settingIndentationLevel(of: line2Range, to: 1)
        let expectedText =
            "\t" + "line 1" + "\n" +
            "\t" + "line 2"
        XCTAssertEqual(newText, expectedText)
    }
}
