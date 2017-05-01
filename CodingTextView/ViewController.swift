//
//  ViewController.swift
//  CodingTextView
//
//  Created by Lennart Wisbar on 24.04.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codingTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codingTextView.delegate = self
    }
}

extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cursorPosition = textView.selectedTextRange?.start else { return true }
        var inputHasBeenModified = false
        
        switch text {
        case ".":   // test case
            print(textView.range(textView.lineFromStartToCursor!, contains: "switch"))
            inputHasBeenModified = true
        case "\n":
            // TODO: If first part of line contains "case", that line's indentation should be adapted to its switches indentation
            // TODO: If you type "{}", then put the cursor between the braces and hit enter, the result is not good
            guard let firstPartOfLine = textView.lineFromStartToCursor else { return true }
            let previousCharacter = textView.characterBefore(cursorPosition)
            let indentationLevel = textView.currentIndentationLevel
            textView.newLine()
            textView.indentCurrentLine(indentationLevel)
            if previousCharacter == "{" {
                if !textView.range(firstPartOfLine, contains: "switch") { textView.indentCurrentLine(); print("no switch") }
                if textView.number(of: previousCharacter) - textView.number(of: previousCharacter.counterpart) > 0 {
                    textView.newLine()
                    textView.indentCurrentLine(indentationLevel)
                    textView.insertText("}")
                    textView.moveCursor(-(Int(indentationLevel)+2))
                }
            }
            inputHasBeenModified = true
        case "(", "[":
            if textView.number(of: text) - textView.number(of: text.counterpart) >= 0 {
                textView.insertText(text + text.counterpart)
                textView.moveCursor(-1)
                inputHasBeenModified = true
            }
        case "}", ")", "]":
            if textView.characterAfter(cursorPosition) == text
                && textView.number(of: text) - textView.number(of: text.counterpart) >= 0 {
                textView.moveCursor()
                inputHasBeenModified = true
            } else if textView.number(of: text) - textView.number(of: text.counterpart) >= 0 {
                // TODO: play warning sound
                print("too many closed brackets")
            }
        case "\"":
            let occurrences = textView.number(of: text)
            guard (occurrences % 2) == 0 else { return true }
            if textView.characterAfter(cursorPosition) == text {
                textView.moveCursor()
                inputHasBeenModified = true
            } else {
                textView.insertText(text + text)
                textView.moveCursor(-1)
                inputHasBeenModified = true
            }
        default:
            return true
        }
        
        return !inputHasBeenModified
    }
    
    // MARK: - Helpers
    private func indentation(level: Int) -> String {
        var indentation = ""
        var i = level
        while i > 0 { indentation += "\t"; i -= 1 }
        return indentation
    }
}

private extension UITextView {
    var currentLine: UITextRange? {
        let newLine = "\n"
        let beginning = positionAfterPrevious(newLine) ?? beginningOfDocument
        let end = positionBeforeNext(newLine) ?? endOfDocument
        return textRange(from: beginning, to: end)
    }
    
    var lineFromStartToCursor: UITextRange? {
        guard let start = currentLine?.start,
            let cursorPosition = selectedTextRange?.start else { return nil }
        return textRange(from: start, to: cursorPosition)
    }
    
    var currentIndentationLevel: UInt {
        guard let startOfLine = currentLine?.start else { return 0 }
        var offset = 0
        var indentationLevel: UInt = 0
        var nextCharacter = ""
        
        while true {
            guard let currentPosition = self.position(from: startOfLine, offset: offset) else { break }
            nextCharacter = characterAfter(currentPosition)
            if nextCharacter == "\t" { indentationLevel += 1; offset += 1 }
            else { break }
        }
        
        return indentationLevel
    }
    
    func characterBefore(_ position: UITextPosition) -> String {
        guard let range = characterRange(byExtending: position, in: UITextLayoutDirection.left),
            let character = text(in: range) else { return "" }
        return character
    }
    
    func characterAfter(_ position: UITextPosition) -> String {
        guard let range = characterRange(byExtending: position, in: UITextLayoutDirection.right),
            let character = text(in: range) else { return "" }
        return character
    }
    
    func positionAfterPrevious(_ string: String) -> UITextPosition? {
        guard let cursorPosition = selectedTextRange?.start else { return nil }
        var previousCharacter: String?
        var offset = 0
        var position = UITextPosition()
        while previousCharacter != string {
            guard let currentPosition = self.position(from: cursorPosition, offset: offset) else { return nil }
            position = currentPosition
            previousCharacter = characterBefore(currentPosition)
            offset -= 1
        }
        return position
    }
    
    func positionBeforeNext(_ string: String) -> UITextPosition? {
        guard let cursorPosition = selectedTextRange?.start else { return nil }
        var nextCharacter: String?
        var offset = 0
        var position = UITextPosition()
        while nextCharacter != string {
            guard let currentPosition = self.position(from: cursorPosition, offset: offset) else { return nil }
            position = currentPosition
            nextCharacter = characterAfter(currentPosition)
            offset += 1
        }
        return position
    }
    
    func number(of string: String) -> Int {
        guard let wholeDocument = textRange(from: beginningOfDocument, to: endOfDocument) else { return 0 }
        return number(of: string, in: wholeDocument)
    }
    
    func number(of string: String, in range: UITextRange) -> Int {
        guard let text = text(in: range) else { return 0 }
        let split = text.components(separatedBy: string)
        return split.count-1
    }
    
    func range(_ range: UITextRange, contains string: String) -> Bool {
        return (number(of: string, in: range)) > 0
    }
    
    func newLine(_ times: UInt = 1) {
        for _ in 1...times { insertText("\n") }
    }
    
    func indentCurrentLine(_ level: UInt = 1) {
        guard level > 0,
            let originalCursorPosition = selectedTextRange?.start,
            let beginningOfLine = currentLine?.start else { return }
        moveCursor(to: beginningOfLine)
        for _ in 1...level { insertText("\t") }
        moveCursor(to: originalCursorPosition)
        moveCursor(Int(level))
    }
    
    func moveCursor(_ offset: Int = 1) {
        guard let oldCursorPosition = selectedTextRange?.start,
            let newCursorPosition = self.position(from: oldCursorPosition, offset: offset) else { return }
        selectedTextRange = textRange(from: newCursorPosition, to: newCursorPosition)
    }
    
    func moveCursor(to position: UITextPosition) {
        selectedTextRange = textRange(from: position, to: position)
    }
}

private extension String {
    var counterpart: String {
        switch self {
        case "(": return ")"
        case ")": return "("
        case "[": return "]"
        case "]": return "["
        case "{": return "}"
        case "}": return "{"
        default: return ""
        }
    }
}
