//
//  ViewController.swift
//  Calculator
//
//  Created by Nikolay Ratushnyak on 08.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    enum CalculationError: Error {
        case lastSymbolDot
        case lastSymbolOperator
        case invalidExpression
    }

    @IBAction func ACButtonAction(_ sender: Any) {
        animateButton(button: acOutlet)
        inputFieldOutlet.text? = ""
    }
    
    @IBAction func PlusMinusAction(_ sender: Any) {
        animateButton(button: plusMinusOutlet)
        if let inputField = inputFieldOutlet.text {
            if (inputField.count != 0) {
                if (inputField.hasPrefix("-(")) {
                    inputFieldOutlet.text?.removeFirst()
                    removeBrackets(field: inputFieldOutlet)
                } else {
                    addBrackets(field: inputFieldOutlet)
                    inputFieldOutlet.text?.insert("-", at: inputField.startIndex)
                }
            }
        }
    }
    
    @IBAction func percentAction(_ sender: Any) {
        animateButton(button: percentOutlet)
        if (inputFieldOutlet.text?.count != 0) {
            addBrackets(field: inputFieldOutlet)
            inputFieldOutlet.text?.append("*0.01")
        }
    }
    
    @IBAction func oneAction(_ sender: Any) {
        animateButton(button: oneOutlet)
        inputFieldOutlet.text?.append("1")
    }
    @IBAction func twoAction(_ sender: Any) {
        animateButton(button: twoOutlet)
        inputFieldOutlet.text?.append("2")
    }
    @IBAction func fiveAction(_ sender: Any) {
        animateButton(button: fiveOutlet)
        inputFieldOutlet.text?.append("5")
    }
    @IBAction func sixAction(_ sender: Any) {
        animateButton(button: sixOutlet)
        inputFieldOutlet.text?.append("6")
    }
    @IBAction func divideAction(_ sender: Any) {
        animateButton(button: divideOutlet)
        if (!isLastOperator(field: inputFieldOutlet) && inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.append("/")
        }
    }
    @IBAction func eightAction(_ sender: Any) {
        animateButton(button: eightOutlet)
        inputFieldOutlet.text?.append("8")
    }
    @IBAction func nineAction(_ sender: Any) {
        animateButton(button: nineOutlet)
        inputFieldOutlet.text?.append("9")
    }
    @IBAction func deleteAction(_ sender: Any) {
        animateButton(button: deleteOutlet)
        if (inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.removeLast()
        }
    }
    @IBAction func sevenAction(_ sender: Any) {
        animateButton(button: sevenOutlet)
        inputFieldOutlet.text?.append("7")
    }
    @IBAction func fourAction(_ sender: Any) {
        animateButton(button: fourOutlet)
        inputFieldOutlet.text?.append("4")
    }
    @IBAction func minusAction(_ sender: Any) {
        animateButton(button: minusOutlet)
        if (!isLastOperator(field: inputFieldOutlet)) {
            inputFieldOutlet.text?.append("-")
        }
    }
    @IBAction func multiplyAction(_ sender: Any) {
        animateButton(button: multiplyOutlet)
        if (!isLastOperator(field: inputFieldOutlet) && inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.append("*")
        }
    }
    @IBAction func equalAction(_ sender: Any) {
        animateButton(button: equalOutlet)
            
            do {
                try validateInput()
                
                if let inputField = inputFieldOutlet.text, !inputField.isEmpty {
                    let expression = NSExpression(format: inputField)
                    if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                        inputFieldOutlet.text = String(result)
                    } else {
                        throw CalculationError.invalidExpression
                    }
                }
            } catch CalculationError.lastSymbolDot {
                inputFieldOutlet.text = "'.' can't be last symbol"
            } catch CalculationError.lastSymbolOperator {
                inputFieldOutlet.text = "Operator can't be last"
            } catch CalculationError.invalidExpression {
                inputFieldOutlet.text = "Incorrect input"
            } catch {
                inputFieldOutlet.text = "Unknown error"
            }
        }
    @IBAction func plusAction(_ sender: Any) {
        animateButton(button: plusOutlet)
        if (!isLastOperator(field: inputFieldOutlet)) {
            inputFieldOutlet.text?.append("+")
        }
    }
    @IBAction func commaAction(_ sender: Any) {
        animateButton(button: commaOutlet)
        if (!isLastDot(field: inputFieldOutlet) && inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.append(".")
        }
    }
    @IBAction func zeroAction(_ sender: Any) {
        animateButton(button: zeroOutlet)
        inputFieldOutlet.text?.append("0")
    }
    @IBAction func threeAction(_ sender: Any) {
        animateButton(button: threeOutlet)
        inputFieldOutlet.text?.append("3")
    }
    
    @IBOutlet weak var inputFieldOutlet: UILabel!
    @IBOutlet weak var oneOutlet: UIButton!
    @IBOutlet weak var twoOutlet: UIButton!
    @IBOutlet weak var threeOutlet: UIButton!
    @IBOutlet weak var fourOutlet: UIButton!
    @IBOutlet weak var fiveOutlet: UIButton!
    @IBOutlet weak var sixOutlet: UIButton!
    @IBOutlet weak var sevenOutlet: UIButton!
    @IBOutlet weak var eightOutlet: UIButton!
    @IBOutlet weak var nineOutlet: UIButton!
    @IBOutlet weak var zeroOutlet: UIButton!
    @IBOutlet weak var acOutlet: UIButton!
    @IBOutlet weak var deleteOutlet: UIButton!
    @IBOutlet weak var commaOutlet: UIButton!
    @IBOutlet weak var plusMinusOutlet: UIButton!
    @IBOutlet weak var equalOutlet: UIButton!
    @IBOutlet weak var multiplyOutlet: UIButton!
    @IBOutlet weak var minusOutlet: UIButton!
    @IBOutlet weak var plusOutlet: UIButton!
    @IBOutlet weak var divideOutlet: UIButton!
    @IBOutlet weak var percentOutlet: UIButton!
    
    func animateButton(button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform.identity
                }
            }
    }
    
    func addBrackets(field: UILabel) {
        if let inputField = field.text {
            field.text?.insert("(", at: inputField.startIndex)
            field.text?.append(")")
        }
    }
    
    func removeBrackets(field: UILabel) {
        field.text?.removeFirst()
        field.text?.removeLast()
    }
    
    func isLastOperator(field: UILabel) -> Bool{
        if let inputField = field.text {
            if(inputField.hasSuffix("+") || inputField.hasSuffix("-") || inputField.hasSuffix("*") || inputField.hasSuffix("/")) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isLastDot(field: UILabel) -> Bool{
        if let inputField = field.text {
            if(inputField.hasSuffix(".")) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func validateInput() throws {
        if isLastDot(field: inputFieldOutlet) {
            throw CalculationError.lastSymbolDot
        }
        
        if isLastOperator(field: inputFieldOutlet) {
            throw CalculationError.lastSymbolOperator
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
