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
    
    // MARK: - completedTextInput(for:in:)
    // MARK: Normal Text
    func test_NormalCharacter_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(3, 0) // "t"
        
        let insertion = "a"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText = "tesat"
        let expectedRange = NSMakeRange(4, 0) // "t"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_InsertedNormally() {
        let text = "test"
        let range = NSMakeRange(3, 0) // "t"

        let insertion = "abc"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText = "tesabct"
        let expectedRange = NSMakeRange(6, 0) // "t"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NormalText_ReplacesSelection() {
        let text = "test abc test"
        let range = NSMakeRange(4, 4) // " abc"
        
        let insertion = "er"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText = "tester test"
        let expectedRange = NSMakeRange(6, 0) // After "tester"
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    // MARK: New Line
    func test_NewLine_MaintainsIndentation() {
        let text =
            "\t\t" + "test"
        let range = NSMakeRange(6, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test" + "\n" +
            "\t\t"
        let expectedRange = NSMakeRange(9, 0) // End
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_AfterCurlyBrace_IndentsAndAddsClosedBrace() {
        let text =
            "\t\t" + "test {"
        let range = NSMakeRange(8, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(12, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_newLine_BetweenCurlyBraces_UsesExistingBrace() {
        let text =
            "\t\t" + "test {}"
        let range = NSMakeRange(8, 0) // Closed brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(12, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_newLine_AfterCurlyBrace_IndentsWithoutAddingClosedBrace_IfTooManyClosedBraces() {
        let text =
            "\t\t" + "test {" + "\n" +
            "another line }"
        let range = NSMakeRange(8, 0) // After open curly brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "test {" + "\n" +
            "\t\t\t" + "\n" +
            "another line }"
        let expectedRange = NSMakeRange(12, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }

    func test_newLine_AfterCurlyBraceAfterSwitch_AddsClosedBraceWithoutIndenting() {
        let text =
            "\t\t" + "switch test {"
        let range = NSMakeRange(15, 0) // End
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(18, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_NewLine_BetweenCurlyBracesAfterSwitch_UsesExistingCurlyBraceWithoutIndenting() {
        let text =
            "\t\t" + "switch test {}"
        let range = NSMakeRange(15, 0) // Closed brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "\n" +
            "\t\t" + "}"
        let expectedRange = NSMakeRange(18, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
    
    func test_newLine_AfterCurlyBraceAfterSwitch_NoBraceOrIndentationAdded_IfTooManyClosedBraces() {
        let text =
            "\t\t" + "switch test {" + "\n" +
            "another line }"
        let range = NSMakeRange(15, 0) // After open curly brace
        
        let insertion = "\n"
        let (newText, newRange) = FormattingHelper.completedTextInput(for: insertion, in: text, range: range)
        
        let expectedText =
            "\t\t" + "switch test {" + "\n" +
            "\t\t" + "\n" +
            "another line }"
        let expectedRange = NSMakeRange(18, 0) // End of second line
        
        XCTAssertEqual(newText, expectedText)
        XCTAssertEqual(newRange.location, expectedRange.location)
        XCTAssertEqual(newRange.length, expectedRange.length)
    }
//
//    // MARK: - Return Key After Curly Brace
//
//    
//    
//    // MARK: - Return Key after "case"
//    func test_ReturnKeyAfterCaseWithColon_IndentsNextLine() {
//        textView.text = "\t\tcase test:"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tcase test:" +
//                        "\n\t\t\t")     // Indentation level raised
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_ReturnKeyAfterCaseWithColonAndSpaces_IndentsNextLine() {
//        textView.text = "\t\tcase test:   "
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tcase test:   " +
//                        "\n\t\t\t")     // Indentation level raised
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_ReturnKeyAfterCaseWithoutColon_DoesNotIndentNextLine() {
//        textView.text = "\t\tcase test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tcase test" +
//                        "\n\t\t")     // Indentation level maintained
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_ReturnKeyAfterCaseWithTextAfterColon_DoesNotIndentNextLine() {
//        textView.text = "\t\tcase test: text"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tcase test: text" +
//                        "\n\t\t")     // Indentation level maintained
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    // MARK: - Return Key After "default"
//    func test_ReturnKeyAfterDefaultWithColon_IndentsNextLine() {
//        textView.text = "\t\tdefault:"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tdefault:" +
//                        "\n\t\t\t")     // Indentation level raised
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_ReturnKeyAfterDefaultWithColonAndSpaces_IndentsNextLine() {
//        textView.text = "\t\tdefault:   "
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tdefault:   " +
//                        "\n\t\t\t")     // Indentation level raised
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_ReturnKeyAfterDefaultWithoutColon_DoesNotIndentNextLine() {
//        textView.text = "\t\tdefault"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tdefault" +
//                        "\n\t\t")     // Indentation level maintained
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_ReturnKeyAfterDefaultWithTextAfterColon_DoesNotIndentNextLine() {
//        textView.text = "\t\tdefault: text"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\n")
//        
//        XCTAssertEqual(textView.text,
//                        "\t\tdefault: text" +
//                        "\n\t\t")     // Indentation level maintained
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    // MARK: - Open Brackets
//    func test_openRoundBracket_ProducesClosedBracket() {
//        textView.text = "test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("(")
//        
//        XCTAssertEqual(textView.text, "test()") // Bracket closed
//        XCTAssertEqual(cursorOffsetFromEnd, -1) // Between the brackets
//    }
//    
//    func test_openSquareBracket_ProducesClosedBracket() {
//        textView.text = "test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("[")
//        
//        XCTAssertEqual(textView.text, "test[]") // Bracket closed
//        XCTAssertEqual(cursorOffsetFromEnd, -1) // Between the brackets
//    }
//    
//    func test_openRoundBracket_DoesNotProduceClosedBracket_IfTooManyClosedBrackets() {
//        textView.text = "bracket test)"
//        cursorOffsetFromEnd = -5    // Before "test"
//        textView.insertAsCode("(")
//        
//        XCTAssertEqual(textView.text, "bracket (test)") // No additional bracket
//        XCTAssertEqual(cursorOffsetFromEnd, -5) // After the open bracket
//    }
//    
//    func test_openSquareBracket_DoesNotProduceClosedBracket_IfTooManyClosedBrackets() {
//        textView.text = "bracket test]"
//        cursorOffsetFromEnd = -5    // Before "test"
//        textView.insertAsCode("[")
//        
//        XCTAssertEqual(textView.text, "bracket [test]") // No additional bracket
//        XCTAssertEqual(cursorOffsetFromEnd, -5) // After the open bracket
//    }
//    
//    // MARK: - Closed Round Brackets
//    func test_closedRoundBracketAfterNormalCharacter_TreatedNormally() {
//        textView.text = "bracket (test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode(")")
//        
//        XCTAssertEqual(textView.text, "bracket (test)") // Normal behavior
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_closedRoundBracketBeforeClosedRoundBracket_StepsOver() {
//        textView.text = "bracket (test)"
//        cursorOffsetFromEnd = -1
//        textView.insertAsCode(")")
//        
//        XCTAssertEqual(textView.text, "bracket (test)") // No additional bracket
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_closedRoundBracketBeforeClosedRoundBracket_TreatedNormally_IfTooManyOpenBrackets() {
//        textView.text = "(bracket (test)"
//        cursorOffsetFromEnd = -1
//        textView.insertAsCode(")")
//        
//        XCTAssertEqual(textView.text, "(bracket (test))") // Normal behavior
//        XCTAssertEqual(cursorOffsetFromEnd, -1)
//    }
//    
//    // TODO: Play warning sound when too many closed round brackets in the document
//    
//    // MARK: - Closed Square Brackets
//    func test_closedSquareBracketAfterNormalCharacter_TreatedNormally() {
//        textView.text = "bracket [test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("]")
//        
//        XCTAssertEqual(textView.text, "bracket [test]") // Normal behavior
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_closedSquareBracketBeforeClosedSquareBracket_StepsOver() {
//        textView.text = "bracket [test]"
//        cursorOffsetFromEnd = -1
//        textView.insertAsCode("]")
//        
//        XCTAssertEqual(textView.text, "bracket [test]") // No additional bracket
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_closedSquareBracketBeforeClosedSquareBracket_TreatedNormally_IfTooManyOpenBrackets() {
//        textView.text = "[bracket [test]"
//        cursorOffsetFromEnd = -1
//        textView.insertAsCode("]")
//        
//        XCTAssertEqual(textView.text, "[bracket [test]]") // Normal behavior
//        XCTAssertEqual(cursorOffsetFromEnd, -1)
//    }
//    
//    // TODO: Play warning sound when too many closed square brackets in the document
//    
//    // MARK: - Closed Curly Braces
//    func test_closedCurlyBraceAfterNormalCharacter_TreatedNormally() {
//        textView.text = "bracket {test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("}")
//        
//        XCTAssertEqual(textView.text, "bracket {test}") // Normal behavior
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_closedCurlyBraceBeforeClosedCurlyBrace_StepsOver() {
//        textView.text = "bracket {test}"
//        cursorOffsetFromEnd = -1
//        textView.insertAsCode("}")
//        
//        XCTAssertEqual(textView.text, "bracket {test}") // No additional bracket
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_closedCurlyBraceBeforeClosedCurlyBrace_TreatedNormally_IfTooManyOpenBraces() {
//        textView.text = "{bracket {test}"
//        cursorOffsetFromEnd = -1
//        textView.insertAsCode("}")
//        
//        XCTAssertEqual(textView.text, "{bracket {test}}") // Normal behavior
//        XCTAssertEqual(cursorOffsetFromEnd, -1)
//    }
//    
//    // TODO: Play warning sound when too many closed curly braces in the document
//    
//    // MARK: - Quotation Marks
//    func test_QuotationMark_CompletedByAnotherOne() {
//        textView.text = "test "
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\"")
//        
//        XCTAssertEqual(textView.text, "test \"\"")  // One additional quotation mark
//        XCTAssertEqual(cursorOffsetFromEnd, -1)     // Between the quotes
//    }
//    
//    func test_QuotationMark_TreatedNormally_IfUnevenNumberOfQuotesInDocument() {
//        textView.text = "\"test"
//        cursorOffsetFromEnd = 0
//        textView.insertAsCode("\"")
//        
//        XCTAssertEqual(textView.text, "\"test\"")   // No additional quotation mark
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
//    
//    func test_QuotationMarkBeforeQuotationMark_StepsOver_IfEvenNumberOfQuotesInDocument() {
//        textView.text = "\"test\""
//        cursorOffsetFromEnd = -1    // After "test"
//        textView.insertAsCode("\"")
//        
//        XCTAssertEqual(textView.text, "\"test\"")   // One additional quotation mark
//        XCTAssertEqual(cursorOffsetFromEnd, 0)
//    }
    
    
    //
    //    // MARK: - Colon
    //    func test_ColonAfterCase_AdoptsSwitchIndentation() {
    //        textView.text = "\t\tswitch test {" +
    //                        "\n\t\t\tcase" +
    //                        "\n\t\t}"
    //        cursorOffsetFromEnd = -4    // After the open curly brace
    //        textView.insertAsCode(":")
    //
    //        XCTAssertEqual(textView.text,
    //                        "\t\tswitch test {" +
    //                        "\n\t\tcase:" +     // Colon after "case", one tab removed
    //                        "\n\t\t}")
    //        XCTAssertEqual(cursorOffsetFromEnd, -4) // after the typed colon
    //    }
    //
    //    func test_ColonAfterDefault_AdoptsSwitchIndentation() {
    //        textView.text = "\t\tswitch test {" +
    //                        "\n\t\t\tdefault" +
    //                        "\n\t\t}"
    //        cursorOffsetFromEnd = -4    // After the open curly brace
    //        textView.insertAsCode(":")
    //
    //        XCTAssertEqual(textView.text,
    //                        "\t\tswitch test {" +
    //                        "\n\t\tdefault:" +     // Colon after "default", one tab removed
    //                        "\n\t\t}")
    //        XCTAssertEqual(cursorOffsetFromEnd, -4) // After the typed colon
    //    }
    //
    //    func test_ColonAfterCase_TreatedNormally_IfNoSwitch() {
    //        textView.text = "\t\t\tcase"
    //        cursorOffsetFromEnd = 0
    //        textView.insertAsCode(":")
    //
    //        XCTAssertEqual(textView.text, "\t\t\tcase:")    // No tabs removed
    //        XCTAssertEqual(cursorOffsetFromEnd, 0)
    //    }
    //
    //    func test_Colon_TreatedNormally_IfNoCaseOrDefault() {
    //        textView.text = "\t\t\tnormalText"
    //        cursorOffsetFromEnd = 0
    //        textView.insertAsCode(":")
    //
    //        XCTAssertEqual(textView.text,
    //                       "\t\t\tnormalText:")    // No tabs removed
    //        XCTAssertEqual(cursorOffsetFromEnd, 0)
    //    }
    
    // MARK: - Helper Tests
    // Helper methods should be made private once they pass the test (or at least at some point in the future)
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
        let stringRange = text.stringRange(from: range)
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
        let tabs = FormattingHelper.tabs(for: 3)
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
    
    func test_numberOfStringInRange() {
        let text = "ab..cdef..ghi..jkl..mnop...qrs."
        let range = text.startIndex..<text.endIndex
        let number = text.number(of: "..", in: range)
        let expectedNumber = 5
        XCTAssertEqual(expectedNumber, number)
    }
}
