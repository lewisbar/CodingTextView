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
        
        let (newText, newRange) = FormattingHelper.formattedText(for: text, in: textView.text, range: range)
        textView.text = newText
        textView.selectedRange = newRange
        
        return false
    }
}

struct FormattingHelper {
    // MARK: Internal Interface
    static func formattedText(for input: String, in text: String, range: NSRange) -> (newText: String, newRange: NSRange) {
        guard let selection = text.stringRange(from: range),
            let scenario = FormattingHelper.scenario(for: input, in: text, range: range) else { return (text, range) }
        
        let line = text.lineRange(for: selection.lowerBound..<selection.lowerBound)
        let indentation = text.indentationLevel(of: line)
        
        var (insertion, cursorOffset) = completedInput(for: input, scenario: scenario, indentation: indentation)
        
        var newText = text.replacingCharacters(in: selection, with: insertion)
        
        // Change the indentation of the current line if needed
        // TODO: Refactor indentation correction into its own method?
        if scenario == .colonAfterCaseOrDefault,
            let switchIndentation = text.indentationLevelOfLast("switch", before: selection.lowerBound) {
            let newCursor = newText.index(selection.lowerBound, offsetBy: cursorOffset)
            let newLine = newText.lineRange(for: newCursor..<newCursor)
            newText = newText.settingIndentationLevel(of: newLine, to: switchIndentation)
            cursorOffset += (switchIndentation - indentation)
        }
        
        let newLocation = range.location + cursorOffset
        let newRange = NSMakeRange(newLocation, 0)
        
        return (newText: newText, newRange: newRange)
    }
}

// MARK: Private Implementation
// TODO: Mark as private
extension FormattingHelper {
    enum Scenario {
        case normal
        case newLine
        case newLineAfterCurlyBrace
        case newLineBetweenCurlyBraces
        case newLineAfterCurlyBraceAlreadyClosed
        case newLineAfterCurlyBraceAfterSwitch
        case newLineBetweenCurlyBracesAfterSwitch
        case newLineAfterCurlyBraceAlreadyClosedAfterSwitch
        case newLineAfterColonAfterCaseOrDefault
        case colonAfterCaseOrDefault
        case openRoundBracket
        case openSquareBracket
        case closedRoundBracketBeforeClosedBracket
        case closedSquareBracketBeforeClosedBracket
        case closedCurlyBraceBeforeClosedCurlyBrace
        case quotationMark
        case quotationMarkBeforeQuotationMark
    }
    
    static func completedInput(for input: String, scenario: Scenario, indentation: Int) -> (String, cursorOffset: Int) {
        var insertion = input
        var cursorOffset = input.characters.count
        
        switch scenario {
        case .normal:
            insertion = input
            cursorOffset = insertion.characters.count
        case .newLine:
            let completion = String.tabs(for: indentation)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .newLineAfterCurlyBrace:
            var completion = String.tabs(for: indentation + 1)
            completion += "\n"
            completion += String.tabs(for: indentation)
            completion += "}"
            insertion = input + completion
            cursorOffset = input.characters.count + indentation + 1
        case .newLineBetweenCurlyBraces:
            var completion = String.tabs(for: indentation + 1)
            completion += "\n"
            completion += String.tabs(for: indentation)
            insertion = input + completion
            cursorOffset = input.characters.count + indentation + 1
        case .newLineAfterCurlyBraceAlreadyClosed:
            let completion = String.tabs(for: indentation + 1)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .newLineAfterCurlyBraceAfterSwitch:
            var completion = String.tabs(for: indentation)
            completion += "\n"
            completion += String.tabs(for: indentation)
            completion += "}"
            insertion = input + completion
            cursorOffset = input.characters.count + indentation
        case .newLineBetweenCurlyBracesAfterSwitch:
            var completion = String.tabs(for: indentation)
            completion += "\n"
            completion += String.tabs(for: indentation)
            insertion = input + completion
            cursorOffset = input.characters.count + indentation
        case .newLineAfterCurlyBraceAlreadyClosedAfterSwitch:
            let completion = String.tabs(for: indentation)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .newLineAfterColonAfterCaseOrDefault:
            let completion = String.tabs(for: indentation + 1)
            insertion = input + completion
            cursorOffset = insertion.characters.count
        case .colonAfterCaseOrDefault:
            insertion = input
            cursorOffset = insertion.characters.count
        case .openRoundBracket:
            insertion = input + ")"
            cursorOffset = input.characters.count
        case .openSquareBracket:
            insertion = input + "]"
            cursorOffset = input.characters.count
        case .closedRoundBracketBeforeClosedBracket:
            insertion = ""
            cursorOffset = input.characters.count
        case .closedSquareBracketBeforeClosedBracket:
            insertion = ""
            cursorOffset = input.characters.count
        case .closedCurlyBraceBeforeClosedCurlyBrace:
            insertion = ""
            cursorOffset = input.characters.count
        case .quotationMark:
            insertion = input + "\""
            cursorOffset = input.characters.count
        case .quotationMarkBeforeQuotationMark:
            insertion = ""
            cursorOffset = input.characters.count
        }
        
        return (insertion, cursorOffset: cursorOffset)
    }
    
    static func scenario(for input: String, in text: String, range: NSRange) -> Scenario? {
        guard let selection = text.stringRange(from: range) else { return nil }
        
        let previousCharacter = text.character(before: selection.lowerBound, ignoring: [" ", "\t"])
        let nextCharacter = text.character(at: selection.lowerBound, ignoring: [" "])
        
        let lineRange = text.lineRange(for: selection.lowerBound..<selection.lowerBound)
        let line = text.substring(with: lineRange)
        let distilledLine = line.components(separatedBy: .whitespacesAndNewlines).joined()
        let isValidSwitchLine: Bool = { return distilledLine.hasPrefix("switch") && distilledLine != "switch{" }()
        
        var scenario = Scenario.normal
        
        switch input {
        case "\n" where previousCharacter == "{" && nextCharacter == "}":
            if isValidSwitchLine {
                scenario = .newLineBetweenCurlyBracesAfterSwitch
            } else {
                scenario = .newLineBetweenCurlyBraces
            }
        case "\n" where previousCharacter == "{" && text.number(of: "}") >= text.number(of: "{"):
            if isValidSwitchLine {
                scenario = .newLineAfterCurlyBraceAlreadyClosedAfterSwitch
            } else {
                scenario = .newLineAfterCurlyBraceAlreadyClosed
            }
        case "\n" where previousCharacter == "{":
            if isValidSwitchLine {
                scenario = .newLineAfterCurlyBraceAfterSwitch
            } else {
                scenario = .newLineAfterCurlyBrace
            }
        case "\n" where (previousCharacter == ":") &&
            ((distilledLine.hasPrefix("case") && distilledLine != "case:") || distilledLine == "default:"):
            scenario = .newLineAfterColonAfterCaseOrDefault
        case "\n":
            scenario = .newLine
        case ":" where ((distilledLine.hasPrefix("case") && distilledLine != "case") || distilledLine == "default"):
            scenario = .colonAfterCaseOrDefault
        case "(" where text.number(of: "(") >= text.number(of: ")"):
            scenario = .openRoundBracket
        case "[" where text.number(of: "[") >= text.number(of: "]"):
            scenario = .openSquareBracket
        case ")" where nextCharacter == ")" && (text.number(of: "(") <= text.number(of: ")")):
            scenario = .closedRoundBracketBeforeClosedBracket
        case "]" where nextCharacter == "]" && (text.number(of: "[") <= text.number(of: "]")):
            scenario = .closedSquareBracketBeforeClosedBracket
        case "}" where nextCharacter == "}" && (text.number(of: "{") <= text.number(of: "}")):
            scenario = .closedSquareBracketBeforeClosedBracket
        case "\"" where nextCharacter == "\"" && (text.number(of: "\"") % 2 == 0):
            scenario = .closedSquareBracketBeforeClosedBracket
        case "\"" where text.number(of: "\"") % 2 == 0:
            scenario = .quotationMark
        default:
            break
        }
        
        return scenario
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
    
    func indentationLevel(of line: Range<String.Index>) -> Int {
        var level = 0
        var position = line.lowerBound
        
        while position != line.upperBound {
            let character = self.characters[position]
            if character == "\t" { level += 1 } else { break }
            position = index(after: position)
        }
        return level
    }
    
    func indentationLevelOfLast(_ phrase: String, before position: String.Index) -> Int? {
        guard let switchRange = range(ofClosest: "switch", before: position) else { return nil }
        let switchLine = lineRange(for: switchRange)
        return indentationLevel(of: switchLine)
    }
    
    func removingIndentation(of line: Range<String.Index>) -> String {
        var newText = self
        let indentation = indentationLevel(of: line)
        let endOfTabs = index(line.lowerBound, offsetBy: indentation)
        newText.removeSubrange(line.lowerBound..<endOfTabs)
        return newText
    }
    
    func settingIndentationLevel(of line: Range<String.Index>, to level: Int) -> String {
        var newText = self.removingIndentation(of: line)
        let tabs = String.tabs(for: level)
        newText.insert(contentsOf: tabs.characters, at: line.lowerBound)
        return newText
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
