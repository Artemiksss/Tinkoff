//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Артём Жовнир on 2024-01-26.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        print(buttonText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

