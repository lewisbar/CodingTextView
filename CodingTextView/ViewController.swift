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
