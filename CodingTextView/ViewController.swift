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
        let previousText = textAtCursorPosition(in: textView, offset: -1)
        var inputHasBeenModified = false
        var cursorOffset = 0
        
        switch text {
        case "\n":
            if previousText == "{" {
                textView.insertText("\n\t\n}")
                cursorOffset = 2
                inputHasBeenModified = true
            }
        case "(":
            textView.insertText("()")
            cursorOffset = 1
            inputHasBeenModified = true
        case "[":
            textView.insertText("[]")
            cursorOffset = 1
            inputHasBeenModified = true
        case ")":
            if textAtCursorPosition(in: textView, offset: 1) == ")" {
                cursorOffset = 1
                inputHasBeenModified = true
            }
        case "]":
            if textAtCursorPosition(in: textView, offset: 1) == "]" {
                cursorOffset = 1
                inputHasBeenModified = true
            }
        case "}":
            if textAtCursorPosition(in: textView, offset: 1) == "}" {
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
    
    private func textAtCursorPosition(in textView: UITextView, offset: Int = 0) -> String {
        guard let currentPosition = textView.selectedTextRange?.start,
            let newPosition = textView.position(from: currentPosition, offset: offset),
            let previousRange = textView.textRange(from: currentPosition, to: newPosition),
            let text = textView.text(in: previousRange) else { return "" }
        return text
    }
}
