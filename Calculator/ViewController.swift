//
//  ViewController.swift
//  Calculator
//
//  Created by Enara Lopez Otaegi on 5/4/17.
//  Copyright © 2017 Enara Lopez Otaegi. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Double {
    var cleanValue: String {
        let formatter = Formatter.withSeparator
        let num = NSNumber(value: self)
        return formatter.string(from: num)!
    }
}

extension String {
    var formattedString: String {
        let formatter = Formatter.withSeparator
        var formattedString = self
        formattedString = formattedString.replacingOccurrences(of: ".", with: "")
        if let doubleValue = Double(formattedString) {
            let numberValue = NSNumber(value: doubleValue)
            return formatter.string(from: numberValue)!
        }
        return self
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    var userIsInTheMiddleOfTapping = false
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGestureRecognizer.addTarget(displayLabel!, action: #selector(onSwipe(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func didTouchedButton(_ sender: UIButton) {
        resetButtonsLayers()
        let digit = sender.currentTitle!
        if digit == "," && (displayLabel.text?.contains(","))! {
            return
        }

        if userIsInTheMiddleOfTapping {
            let textCurrentlyInDisplay = displayLabel.text!
            let textToDisplay = textCurrentlyInDisplay + digit
            displayLabel.text = textToDisplay.formattedString
        } else {
            if digit == "," {
                displayLabel.text = displayLabel.text! + digit
            } else {
                displayLabel.text = digit
            }
            userIsInTheMiddleOfTapping = true
        }
        brain.setOperand(displayValue)
    }
    
    var displayValue: Double {
        get {
            let formatter = Formatter.withSeparator
            let num = formatter.number(from: displayLabel.text!)
            return Double(num!)
        }
        set {
            displayLabel.text = newValue.cleanValue
        }
    }
    
    var brain = CalculatorBrain()

    @IBAction func performOperation(_ sender: UIButton) {
        resetButtonsLayers()
        userIsInTheMiddleOfTapping = false
        brain.performOperation(sender.currentTitle!)
        if let result = brain.result {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func setCorner(_ sender: UIButton) {
        resetButtonsLayers()
        sender.borderColor = UIColor.black
    }
    
    @IBAction func onSwipe(_ sender: UISwipeGestureRecognizer) {
        if let textInDisplayLabel = displayLabel.text {
            let textInDisplayLabelSubstring = textInDisplayLabel.substring(to: textInDisplayLabel.endIndex)
            displayLabel.text = textInDisplayLabelSubstring
            brain.setOperand(displayValue)
        }
    }
    
    func resetButtonsLayers() {
        for case let vStackview as UIStackView in self.view.subviews {
            for case let hStackview as UIStackView in vStackview.subviews {
                for case let button as UIButton in hStackview.subviews {
                    button.borderColor = UIColor.lightGray
                }
            }
        }
    }

}

