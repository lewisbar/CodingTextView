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
        //Also possible (which one is better? otherwise I never use range): guard let cursorPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return true }
        var inputHasBeenModified = false
        var cursorOffset = 0
        
        switch text {
        case "\n":
            let previousCharacter = characterBeforeCursorPosition(in: textView)
            let indentationLevel = currentIndentationLevel(in: textView)
            var textToInsert = "\n"
            cursorOffset = 1
            inputHasBeenModified = true
            textToInsert += indentation(level: indentationLevel)
            cursorOffset += indentationLevel
            if previousCharacter == "{",
                difference(between: previousCharacter, and: previousCharacter.counterpart, in: textView) > 0 {
                textToInsert += "\t\n"
                cursorOffset += 1
                textToInsert += indentation(level: indentationLevel)
                cursorOffset += indentationLevel
                textToInsert += "}"
            }
            textView.insertText(textToInsert)
        case "(", "[":
            if difference(between: text, and: text.counterpart, in: textView) >= 0 {
                textView.insertText(text + text.counterpart)
                cursorOffset = 1
                inputHasBeenModified = true
            }
        case "}", ")", "]":
            if characterAfterCursorPosition(in: textView) == text
                && difference(between: text.counterpart, and: text, in: textView) <= 0 {
                cursorOffset = 1
                inputHasBeenModified = true
            } else if difference(between: text.counterpart, and: text, in: textView) <= 0 {
                // TODO: play warning sound
                print("too many closed brackets")
            }
        case "\"":
            let occurrences = number(of: text, in: textView)
            guard (occurrences % 2) == 0 else { return true }
            if characterAfterCursorPosition(in: textView) == text {
                cursorOffset = 1
                inputHasBeenModified = true
            } else {
                textView.insertText(text + text)
                cursorOffset = 1
                inputHasBeenModified = true
            }
        default:
            return true
        }
        
        // Set new cursor position
        if inputHasBeenModified, let newCursorPosition = textView.position(from: cursorPosition, offset: cursorOffset) {
            textView.selectedTextRange = textView.textRange(from: newCursorPosition, to: newCursorPosition)
        }
        
        return !inputHasBeenModified
    }
    
    // MARK: - Helpers
    //TODO: Refactor most of this into an extension UITextView
    private func characterAfterCursorPosition(in textView: UITextView) -> String {
        guard let currentPosition = textView.selectedTextRange?.start,
            let range = textView.characterRange(byExtending: currentPosition, in: UITextLayoutDirection.right),
            let character = textView.text(in: range) else { return "" }
        return character
    }
    
    private func characterBeforeCursorPosition(in textView: UITextView) -> String {
        guard let currentPosition = textView.selectedTextRange?.start,
            let range = textView.characterRange(byExtending: currentPosition, in: UITextLayoutDirection.left),
            let character = textView.text(in: range) else { return "" }
        return character
    }
    
    private func characterAfter(_ position: UITextPosition, in textView: UITextView) -> String {
        guard let range = textView.characterRange(byExtending: position, in: UITextLayoutDirection.right),
            let character = textView.text(in: range) else { return "" }
        return character
    }
    
    private func characterBefore(_ position: UITextPosition, in textView: UITextView) -> String {
        guard let range = textView.characterRange(byExtending: position, in: UITextLayoutDirection.left),
            let character = textView.text(in: range) else { return "" }
        return character
    }
    
    private func positionAfterPrevious(_ string: String, in textView: UITextView) -> UITextPosition? {
        guard let cursorPosition = textView.selectedTextRange?.start else { return nil }
        var previousCharacter: String?
        var offset = -1
        var position = UITextPosition()
        while previousCharacter != string {
            guard let currentPosition = textView.position(from: cursorPosition, offset: offset) else { return nil }
            position = currentPosition
            previousCharacter = characterBefore(currentPosition, in: textView)
            offset -= 1
        }
        return position
    }
    
    private func currentIndentationLevel(in textView: UITextView) -> Int {
        guard let startOfLine = positionAfterPrevious("\n", in: textView) else { return 0 }
        var offset = 0
        var indentationLevel = 0
        var nextCharacter = ""
        
        while true {
            guard let currentPosition = textView.position(from: startOfLine, offset: offset) else { break }
            nextCharacter = characterAfter(currentPosition, in: textView)
            if nextCharacter == "\t" { indentationLevel += 1; offset += 1 }
            else { break }
        }
        
        return indentationLevel
    }
    
    private func indentation(level: Int) -> String {
        var indentation = ""
        var i = level
        while i > 0 { indentation += "\t"; i -= 1 }
        return indentation
    }
    
    private func number(of string: String, in textView: UITextView) -> Int {
        guard let range = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument),
            let text = textView.text(in: range) else { return 0 }
        let split =  text.components(separatedBy: string)
        return split.count-1
    }
    
    private func difference(between string1: String, and string2: String, in textView: UITextView) -> Int {
        let number1 = number(of: string1, in: textView)
        let number2 = number(of: string2, in: textView)
        return number1 - number2
    }

//
//    private func number(ofPreceding string: String, in textView: UITextView) -> Int {
//        guard let currentPosition = textView.selectedTextRange?.start,
//            let range = textView.textRange(from: textView.beginningOfDocument, to: currentPosition),
//            let text = textView.text(in: range) else { return 0 }
//        let split =  text.components(separatedBy: string)
//        return split.count-1
//    }
//    
//    private func number(ofFollowing string: String, in textView: UITextView) -> Int {
//        guard let currentPosition = textView.selectedTextRange?.start,
//            let range = textView.textRange(from: currentPosition, to: textView.endOfDocument),
//            let text = textView.text(in: range) else { return 0 }
//        let split =  text.components(separatedBy: string)
//        return split.count-1
//    }
//    
//
//    private func difference(betweenPreceding string1: String, andPreceding string2: String, in textView: UITextView) -> Int {
//        let number1 = number(ofPreceding: string1, in: textView)
//        let number2 = number(ofPreceding: string2, in: textView)
//        return number1 - number2
//    }
//    
//    private func difference(betweenFollowing string1: String, andFollowing string2: String, in textView: UITextView) -> Int {
//        let number1 = number(ofFollowing: string1, in: textView)
//        let number2 = number(ofFollowing: string2, in: textView)
//        return number1 - number2
//    }
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
