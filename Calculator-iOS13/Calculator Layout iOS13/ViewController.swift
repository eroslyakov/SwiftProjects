//
//  ViewController.swift
//  Calculator Layout iOS13
//
//  Created by Angela Yu on 01/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    enum ButtonType {
        case Value
        case Operation
    }
    
    private var operand: Double?
    private var operation: String?
    
    // intermediate operand utilized for storing additional input in case
    // when in serial calculation lower priority '-' or '+' operation
    // followed by multiplication or division (which has higher priority), e.g.:
    // 2 + 3 * 4 * 2 = 26 (not 40)
    private var intermediateOperand: Double?
    private var intermediateOperation: String?
    
    private var isFinishedTypingNumber = true
    private var previousTappedButton: ButtonType? = ButtonType.Operation
    
    private var numericValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("Cannot convert display text to a Double")
            }
            return number
        }
        set {
            if newValue.truncatingRemainder(dividingBy: 1) == 0.0 {
                displayLabel.text = String(format: "%.0f", newValue)
            } else {
                displayLabel.text = String(newValue)[0...8]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func calcButtonPressed(_ sender: UIButton) {
        guard let display = displayLabel.text else {
            return
        }
        
        isFinishedTypingNumber = true
        // if user taps two and more operations one after another
        // this guard will choose the last of them
        guard previousTappedButton == ButtonType.Value else {
            if intermediateOperation != nil {
                intermediateOperation = sender.currentTitle
            } else if operation != nil {
                operation = sender.currentTitle
            }
            return
        }
        
        switch sender.currentTitle {
        case "+/-":
            numericValue = numericValue * -1
            return
        case "AC":
            numericValue = 0
            operand = nil
            operation = nil
            intermediateOperand = nil
            intermediateOperation = nil
            previousTappedButton = nil
            return
        case "%" where display != "0":
            numericValue = numericValue * 0.01
        case "÷":
            fallthrough
        case "×":
            if intermediateOperation != nil {
                calculateOptional()
                intermediateOperation = sender.currentTitle
            } else if operation != nil {
                if operation == "+" || operation == "-" {
                    intermediateOperation = sender.currentTitle
                    intermediateOperand = numericValue
                } else {
                    calculate()
                    operation = sender.currentTitle
                }
            } else {
                operation = sender.currentTitle
                operand = numericValue
            }
        case "-":
            fallthrough
        case "+":
            if intermediateOperation != nil {
                calculateOptional()
                calculate()
            } else if operation != nil {
                calculate()
            } else {
                operand = numericValue
            }
            operation = sender.currentTitle
        default:
            if intermediateOperation != nil {
                calculateOptional()
                calculate()
            } else if operation != nil {
                calculate()
            }
            return
        }
        previousTappedButton = ButtonType.Operation
    }
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        guard let numValue = sender.currentTitle, displayLabel.text!.count < 10 else {
            return
        }
        guard !(numValue == "." && displayLabel.text!.contains(numValue)) else {
            return
        }
        
        if isFinishedTypingNumber {
            displayLabel.text = numValue
            isFinishedTypingNumber = false
        } else {
            displayLabel.text = displayLabel.text! + numValue
        }
        previousTappedButton = ButtonType.Value
    }
    
    func calculate() {
        switch operation {
        case "÷":
            numericValue = operand! / numericValue
        case "×":
            numericValue = operand! * numericValue
        case "-":
            numericValue = operand! - numericValue
        case "+":
            numericValue = operand! + numericValue
        default:
            return
        }
        operand = numericValue
        operation = nil
        intermediateOperand = nil
        intermediateOperation = nil
    }
    
    func calculateOptional() {
        if let intermediateOperation = intermediateOperation, let intermediateOperand = intermediateOperand {
            if intermediateOperation == "×" {
                self.intermediateOperand = intermediateOperand * numericValue
            } else {
                self.intermediateOperand = intermediateOperand / numericValue
            }
            numericValue = self.intermediateOperand!
        }
    }
    
}

extension String {
    subscript(range: ClosedRange<Int>) -> String {
        let startIdx = index(startIndex, offsetBy: range.min()!)
        let endIdx = index(startIdx, offsetBy: min(count - 1, range.max()!))
        return String(self[startIdx...endIdx])
    }
}

