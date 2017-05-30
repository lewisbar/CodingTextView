//
//  FormattingHelper.swift
//  CodingTextView
//
//  Created by Lennart Wisbar on 15.05.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit

extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let (newText, newRange) = FormattingHelper.completedTextInput(for: text, in: textView.text, range: range)
        textView.text = newText
        textView.selectedRange = newRange
        
        return false
    }
}

struct FormattingHelper {
    // MARK: Internal Interface
    static func completedTextInput(for input: String, in text: String, range: NSRange) -> (newText: String, newRange: NSRange) {
        
        guard let selection = text.stringRange(from: range) else { return (text, range) }
        
        let previousCharacter = text.character(before: selection.lowerBound, ignoring: [" "])
        let nextCharacter = text.character(at: selection.lowerBound, ignoring: [" "])
        
        let line = text.rangeOfLine(around: selection.lowerBound)
        let trimmedLine = text.substring(with: line).trimmingCharacters(in: .whitespaces)
        let indentation = text.indentationLevel(of: line)
        
        var insertion = input
        var cursorOffset = insertion.characters.count
        var scenario = Scenario.normal
        
        if input == "\n" {
            if previousCharacter == "{" {
                if trimmedLine.hasPrefix("switch") {
                    if nextCharacter == "}" {
                        scenario = .newLineBetweenCurlyBracesAfterSwitch
                    } else if text.number(of: "}") >= text.number(of: "{") {
                        scenario = .newLineAfterCurlyBraceAlreadyClosedAfterSwitch
                    } else {
                        scenario = .newLineAfterCurlyBraceAfterSwitch
                    }
                } else {
                    if nextCharacter == "}" {
                        scenario = .newLineBetweenCurlyBraces
                    } else if text.number(of: "}") >= text.number(of: "{") {
                        scenario = .newLineAfterCurlyBraceAlreadyClosed
                    } else {
                        scenario = .newLineAfterCurlyBrace
                    }
                }
            } else if previousCharacter == ":", trimmedLine.hasPrefix("case") {
                scenario = .newLineAfterColonAfterCase
            } else {
                scenario = .newLine
            }
        }
        
        (insertion, cursorOffset) = completedInput(for: input, scenario: scenario, indentation: indentation)
        
        let newText = text.replacingCharacters(in: selection, with: insertion)
        let newLocation = range.location + cursorOffset
        let newRange = NSMakeRange(newLocation, 0)
        
        return (newText: newText, newRange: newRange)
    }
    
    // MARK: Private Implementation
    // TODO: Mark as private
    enum Scenario {
        case normal
        case newLine
        case newLineAfterCurlyBrace
        case newLineBetweenCurlyBraces
        case newLineAfterCurlyBraceAlreadyClosed
        case newLineAfterCurlyBraceAfterSwitch
        case newLineBetweenCurlyBracesAfterSwitch
        case newLineAfterCurlyBraceAlreadyClosedAfterSwitch
        case newLineAfterColonAfterCase
    }
    
    static func completedInput(for input: String, scenario: Scenario, indentation: Int) -> (String, cursorOffset: Int) {
        var insertion = ""
        var cursorOffset = 0
        
        switch scenario {
        case .normal:
            insertion = input
            cursorOffset = insertion.characters.count
        case .newLine:
            let completion = tabs(for: indentation)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .newLineAfterCurlyBrace:
            var completion = tabs(for: indentation + 1)
            completion += "\n"
            completion += tabs(for: indentation)
            completion += "}"
            insertion = input + completion
            cursorOffset = input.characters.count + indentation + 1
        case .newLineBetweenCurlyBraces:
            var completion = tabs(for: indentation + 1)
            completion += "\n"
            completion += tabs(for: indentation)
            insertion = input + completion
            cursorOffset = input.characters.count + indentation + 1
        case .newLineAfterCurlyBraceAlreadyClosed:
            let completion = tabs(for: indentation + 1)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .newLineAfterCurlyBraceAfterSwitch:
            var completion = tabs(for: indentation)
            completion += "\n"
            completion += tabs(for: indentation)
            completion += "}"
            insertion = input + completion
            cursorOffset = input.characters.count + indentation
        case .newLineBetweenCurlyBracesAfterSwitch:
            var completion = tabs(for: indentation)
            completion += "\n"
            completion += tabs(for: indentation)
            insertion = input + completion
            cursorOffset = input.characters.count + indentation
        case .newLineAfterCurlyBraceAlreadyClosedAfterSwitch:
            let completion = tabs(for: indentation)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .newLineAfterColonAfterCase:
            let completion = tabs(for: indentation + 1)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        }
        
        return (insertion, cursorOffset: cursorOffset)
    }
    
    static func tabs(for indentation: Int) -> String {
        var tabs = ""
        if indentation > 0 {
            for _ in 1...indentation {
                tabs += "\t"
            }
        }
        return tabs
    }
}

// TODO: Mark as private
extension String {

    func stringRange(from range: NSRange) -> Range<String.Index>? {
        guard (range.location + range.length) <= characters.count else { return nil }
        let start = self.index(self.startIndex, offsetBy: range.location)
        let end = self.index(start, offsetBy: range.length)
        return start..<end
    }
    
    func range(ofClosest text: String, before position: String.Index) -> Range<String.Index>? {
        guard var startOfRange = self.index(position, offsetBy: -text.characters.count, limitedBy: startIndex) else { return nil }
        var endOfRange = position

        while true {
            let range = startOfRange..<endOfRange
            let candidate = substring(with: range)
            if candidate == text { return range }
            guard let newStart = self.index(startOfRange, offsetBy: -1, limitedBy: startIndex) else { return nil }
            startOfRange = newStart
            endOfRange = index(before: endOfRange)
        }
    }
    
    func range(ofClosest text: String, after position: String.Index) -> Range<String.Index>? {
        guard var endOfRange = self.index(position, offsetBy: text.characters.count, limitedBy: endIndex) else { return nil }
        var startOfRange = position
        
        while true {
            let range = startOfRange..<endOfRange
            let candidate = substring(with: range)
            if candidate == text { return range }
            guard let newEnd = self.index(endOfRange, offsetBy: 1, limitedBy: endIndex) else { return nil }
            endOfRange = newEnd
            startOfRange = index(after: startOfRange)
        }
    }
    
    func rangeOfLine(around position: String.Index) -> Range<String.Index> {
        let startOfLine = range(ofClosest: "\n", before: position)?.upperBound ?? startIndex
        let endOfLine = range(ofClosest: "\n", after: position)?.lowerBound ?? endIndex
        
        return startOfLine..<endOfLine
    }
    
    func indentationLevel(of line: Range<String.Index>) -> Int {
        var level = 0
        var position = line.lowerBound
        
        while position != line.upperBound {
            let character = self.characters[position]
            if character == "\t" { level += 1 }
            position = index(after: position)
        }
        return level
    }
    
    func character(at position: String.Index, ignoring: [Character] = []) -> Character? {
        var position = position
        
        while position < endIndex {
            if !ignoring.contains(characters[position]) {
                return characters[position]
            }
            position = index(after: position)
        }
        return nil
    }
    
    func character(before position: String.Index, ignoring: [Character] = []) -> Character? {
        var position = position
        
        while position > startIndex {
            position = index(before: position)
            if !ignoring.contains(characters[position]) {
                return characters[position]
            }
        }
        return nil
    }
    
    func number(of string: String, in range: Range<String.Index>) -> Int {
        let split = components(separatedBy: string)
        return split.count-1
    }
    
    func number(of string: String) -> Int {
        let range = startIndex..<endIndex
        return number(of: string, in: range)
    }
}


    
//    var counterpart: String {
//        switch self {
//        case "(": return ")"
//        case ")": return "("
//        case "[": return "]"
//        case "]": return "["
//        case "{": return "}"
//        case "}": return "{"
//        default: return ""
//        }
//    }
//}



//extension UITextView {
//    // MARK: - Main code formatting function
//    func insertAsCode(_ text: String) {
//        guard let cursorPosition = selectedTextRange?.start else { return }
//        var inputHasBeenModified = false
//        
//        switch text {
//        case ":":
//            // In a switch, set the indentation of a "case" or "default" to the same level as the switch
//            guard let firstPartOfLine = lineFromStartToCursor,
//                self.range(firstPartOfLine, contains: "case") || self.range(firstPartOfLine, contains: "default"),
//                let lastSwitchPosition = positionAfterPrevious("switch") else { break }
//            let caseIndentationLevel = currentIndentationLevel
//            moveCursor(to: lastSwitchPosition)
//            let switchIndentationLevel = currentIndentationLevel
//            moveCursor(to: cursorPosition)
//            indentCurrentLine(switchIndentationLevel - caseIndentationLevel)
//        case "\n":
//            // In any case of the return key being typed, open a new line and maintain indentation
//            guard let firstPartOfLine = lineFromStartToCursor else { break }
//            let previousCharacter = characterBefore(cursorPosition, ignoring: [" ", "\t"])
//            let followingCharacter = characterAfter(cursorPosition)
//            let indentationLevel = currentIndentationLevel
//            newLine()
//            indentCurrentLine(indentationLevel)
//            inputHasBeenModified = true
//            
//            // Additional actions after open curly brace
//            if previousCharacter == "{" {
//                
//                // Cursor between "{}"
//                if followingCharacter == previousCharacter.counterpart {
//                    newLine()
//                    indentCurrentLine(indentationLevel)
//                    moveCursor(-(indentationLevel+1))
//                    indentCurrentLine()
//                    break
//                }
//                
//                // Indent one more unless we are in a switch
//                if !self.range(firstPartOfLine, contains: "switch") { indentCurrentLine() }
//                
//                // More "{" than "}"
//                if number(of: previousCharacter) - number(of: previousCharacter.counterpart) > 0 {
//                    newLine()
//                    indentCurrentLine(indentationLevel)
//                    insertText("}")
//                    moveCursor(-(indentationLevel+2))
//                }
//                
//            // Indent next line after a "case ...:" or "default:"
//            } else if previousCharacter == ":",
//                self.range(firstPartOfLine, contains: "case") || self.range(firstPartOfLine, contains: "default") {
//                indentCurrentLine()
//            }
//        case "(", "[":
//            // Close brackets unless they already are
//            if containsMore(of: text, than: text.counterpart) {
//                insertText(text + text.counterpart)
//                moveCursor(-1)
//                inputHasBeenModified = true
//            }
//        case "}", ")", "]":
//            // Step over closed brackets if typed unnecessarily
//            if characterAfter(cursorPosition) == text
//                && containsMore(of: text, than: text.counterpart) {
//                moveCursor()
//                inputHasBeenModified = true
//                
//            // Play warning if there are too many closed brackets
//            } else if containsMore(of: text, than: text.counterpart) {
//                // TODO: play warning sound
//                print("too many closed brackets")
//            }
//        case "\"":
//            let occurrences = number(of: text)
//            
//            // Only intervene if there is an even number of quotation marks
//            guard (occurrences % 2) == 0 else { break }
//            
//            // Ignore closing of quotation marks if already closed
//            if characterAfter(cursorPosition) == text {
//                moveCursor()
//                inputHasBeenModified = true
//                
//            // Else close opened quotation marks
//            } else {
//                insertText(text + text)
//                moveCursor(-1)
//                inputHasBeenModified = true
//            }
//        case "": // backspace
//            backspace()
//            inputHasBeenModified = true
//        default:
//            break
//        }
//        
//        // If nothing has been modified: Just insert the text as normal
//        if !inputHasBeenModified {
//            insertText(text)
//        }
//    }
//    
//    // MARK: - INFORMATION
//    // MARK: About the current line
//    var currentLine: UITextRange? {
//        let newLine = "\n"
//        let beginning = positionAfterPrevious(newLine) ?? beginningOfDocument
//        let end = positionBeforeNext(newLine) ?? endOfDocument
//        return textRange(from: beginning, to: end)
//    }
//    
//    var lineFromStartToCursor: UITextRange? {
//        guard let start = currentLine?.start,
//            let cursorPosition = selectedTextRange?.start else { return nil }
//        return textRange(from: start, to: cursorPosition)
//    }
//    
//    var currentIndentationLevel: Int {
//        guard let startOfLine = currentLine?.start else { return 0 }
//        var offset = 0
//        var indentationLevel = 0
//        var nextCharacter = ""
//        
//        while true {
//            guard let currentPosition = self.position(from: startOfLine, offset: offset) else { break }
//            nextCharacter = characterAfter(currentPosition)
//            if nextCharacter == "\t" { indentationLevel += 1; offset += 1 }
//            else { break }
//        }
//        
//        return indentationLevel
//    }
//    
//    // MARK: Looking up characters at certain positions
//    func characterBefore(_ position: UITextPosition, ignoring: [String] = []) -> String {
//        guard let range = characterRange(byExtending: position, in: .left),
//            let character = text(in: range) else { return "" }
//        
//        var offset = -1
//        var nextCharacter = character
//        while ignoring.contains(nextCharacter) {
//            guard let nextPosition = self.position(from: position, offset: offset),
//                let nextRange = characterRange(byExtending: nextPosition, in: .left),
//                let character = text(in: nextRange) else { return "" }
//            nextCharacter = character
//            offset -= 1
//        }
//        return nextCharacter
//    }
//    
//    func characterAfter(_ position: UITextPosition, ignoring: [String] = []) -> String {
//        guard let range = characterRange(byExtending: position, in: .right),
//            let character = text(in: range) else { return "" }
//        
//        var offset = 1
//        var nextCharacter = character
//        while ignoring.contains(nextCharacter) {
//            guard let nextPosition = self.position(from: position, offset: offset),
//                let nextRange = characterRange(byExtending: nextPosition, in: .left),
//                let character = text(in: nextRange) else { return "" }
//            nextCharacter = character
//            offset += 1
//        }
//        return nextCharacter
//    }
//    
//    // MARK: Finding nearby strings
//    func positionAfterPrevious(_ string: String) -> UITextPosition? {
//        guard var endOfRange = selectedTextRange?.start,
//            var startOfRange = position(from: endOfRange, offset: -string.characters.count) else { return nil }
//        while true {
//            guard let range = textRange(from: startOfRange, to: endOfRange) else { return nil }
//            if text(in: range) == string {
//                return range.end
//            }
//            guard let newStart = position(from: startOfRange, offset: -1),
//                let newEnd = position(from: endOfRange, offset: -1) else { return nil }
//            startOfRange = newStart
//            endOfRange = newEnd
//        }
//    }
//    
//    func positionBeforeNext(_ string: String) -> UITextPosition? {
//        guard var startOfRange = selectedTextRange?.start,
//            var endOfRange = position(from: startOfRange, offset: string.characters.count) else { return nil }
//        while true {
//            guard let range = textRange(from: startOfRange, to: endOfRange) else { return nil }
//            if text(in: range) == string {
//                return range.start
//            }
//            guard let newStart = position(from: startOfRange, offset: 1),
//                let newEnd = position(from: endOfRange, offset: 1) else { return nil }
//            startOfRange = newStart
//            endOfRange = newEnd
//        }
//    }
//    
//    // MARK: Looking for occurrences of certain strings
//    func number(of string: String) -> Int {
//        guard let wholeDocument = textRange(from: beginningOfDocument, to: endOfDocument) else { return 0 }
//        return number(of: string, in: wholeDocument)
//    }
//    
//    func number(of string: String, in range: UITextRange) -> Int {
//        guard let text = text(in: range) else { return 0 }
//        let split = text.components(separatedBy: string)
//        return split.count-1
//    }
//    
//    func containsMore(of string1: String, than string2: String) -> Bool {
//        return number(of: string1) - number(of: string2) >= 0
//    }
//    
//    func range(_ range: UITextRange, contains string: String) -> Bool {
//        return (number(of: string, in: range)) > 0
//    }
//    
//    // MARK: - ACTIONS
//    func newLine(_ times: UInt = 1) {
//        guard times > 0 else { return }
//        for _ in 1...times { insertText("\n") }
//    }
//    
//    func backspace() {
//        if selectedTextRange?.start == selectedTextRange?.end,
//            let cursorPosition = selectedTextRange?.start,
//            let oneStepBack = position(from: cursorPosition, offset: -1),
//            let range = textRange(from: oneStepBack, to: cursorPosition) {
//            replace(range, withText: "")
//        } else {
//            insertText("")
//        }
//    }
//    
//    func indentCurrentLine(_ steps: Int = 1) {
//        guard let originalCursorPosition = selectedTextRange?.start,
//            let beginningOfLine = currentLine?.start else { return }
//        if steps > 0 {
//            moveCursor(to: beginningOfLine)
//            for _ in 1...steps { insertText("\t") }
//            moveCursor(to: originalCursorPosition)
//            moveCursor(steps)
//        } else if (steps < 0) && (currentIndentationLevel > 0) {
//            let surplusTabsCount = min(-steps, currentIndentationLevel)
//            guard let endOfSurplusTabs = position(from: beginningOfLine, offset: surplusTabsCount),
//                let range = textRange(from: beginningOfLine, to: endOfSurplusTabs),
//                let newCursorPosition = position(from: originalCursorPosition, offset: -surplusTabsCount) else { return }
//            replace(range, withText: "")
//            moveCursor(to: newCursorPosition)
//        }
//    }
//    
//    func moveCursor(_ offset: Int = 1) {
//        guard let oldCursorPosition = selectedTextRange?.start,
//            let newCursorPosition = self.position(from: oldCursorPosition, offset: offset) else { return }
//        selectedTextRange = textRange(from: newCursorPosition, to: newCursorPosition)
//    }
//    
//    func moveCursor(to position: UITextPosition) {
//        selectedTextRange = textRange(from: position, to: position)
//    }
//}
