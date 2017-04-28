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
            let precedingCharacter = characterAfterCursorPosition(in: textView, offset: -1)
            if precedingCharacter == "{" {
                if difference(between: precedingCharacter, and: precedingCharacter.counterpart, in: textView) > 0 {
                    textView.insertText("\n\t\n}")
                } else {
                    textView.insertText("\n\t\n")
                }
                cursorOffset = 2
                inputHasBeenModified = true
            } else if precedingCharacter == "}" {
                // indentation level of the }
            }
            // TODO: Deal with indentation levels
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
    private func characterAfterCursorPosition(in textView: UITextView, offset: Int = 0) -> String {
        guard let currentPosition = textView.selectedTextRange?.start,
            let newPosition = textView.position(from: currentPosition, offset: offset),
            let positionAfterNextCharacter = textView.position(from: newPosition, offset: 1),
            let range = textView.textRange(from: newPosition, to: positionAfterNextCharacter),
            let character = textView.text(in: range) else { return "" }
        return character
    }
    
    private func indentationLevel() -> Int {
        // TODO: find out intentation level of the current line
        return 0
    }
    
    private func number(of string: String, in textView: UITextView) -> Int {
        guard let range = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument),
            let text = textView.text(in: range) else { return 0 }
        let split =  text.components(separatedBy: string)
        return split.count-1
    }
    
    private func number(ofPreceding string: String, in textView: UITextView) -> Int {
        guard let currentPosition = textView.selectedTextRange?.start,
            let range = textView.textRange(from: textView.beginningOfDocument, to: currentPosition),
            let text = textView.text(in: range) else { return 0 }
        let split =  text.components(separatedBy: string)
        return split.count-1
    }
    
    private func number(ofFollowing string: String, in textView: UITextView) -> Int {
        guard let currentPosition = textView.selectedTextRange?.start,
            let range = textView.textRange(from: currentPosition, to: textView.endOfDocument),
            let text = textView.text(in: range) else { return 0 }
        let split =  text.components(separatedBy: string)
        return split.count-1
    }
    
    private func difference(between string1: String, and string2: String, in textView: UITextView) -> Int {
        let number1 = number(of: string1, in: textView)
        let number2 = number(of: string2, in: textView)
        return number1 - number2
    }
    
    private func difference(betweenPreceding string1: String, andPreceding string2: String, in textView: UITextView) -> Int {
        let number1 = number(ofPreceding: string1, in: textView)
        let number2 = number(ofPreceding: string2, in: textView)
        return number1 - number2
    }
    
    private func difference(betweenFollowing string1: String, andFollowing string2: String, in textView: UITextView) -> Int {
        let number1 = number(ofFollowing: string1, in: textView)
        let number2 = number(ofFollowing: string2, in: textView)
        return number1 - number2
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
