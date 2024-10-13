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
    
    private let viewModel = ViewModel()
    private var isError = false

    @IBAction func ACButtonAction(_ sender: Any) {
        viewModel.animateButton(button: acOutlet)
        isError = false
        inputFieldOutlet.text? = ""
    }
    
    @IBAction func PlusMinusAction(_ sender: Any) {
        viewModel.animateButton(button: plusMinusOutlet)
        if let inputField = inputFieldOutlet.text {
            if (inputField.count != 0) {
                if (inputField.hasPrefix("-(")) {
                    inputFieldOutlet.text?.removeFirst()
                    viewModel.removeBrackets(field: inputFieldOutlet)
                } else {
                    viewModel.addBrackets(field: inputFieldOutlet)
                    inputFieldOutlet.text?.insert("-", at: inputField.startIndex)
                }
            }
        }
    }
    
    @IBAction func percentAction(_ sender: Any) {
        viewModel.animateButton(button: percentOutlet)
        if (inputFieldOutlet.text?.count != 0) {
            viewModel.addBrackets(field: inputFieldOutlet)
            inputFieldOutlet.text?.append("*0.01")
        }
    }
    
    @IBAction func oneAction(_ sender: Any) {
        viewModel.animateButton(button: oneOutlet)
        inputFieldOutlet.text?.append("1")
    }
    @IBAction func twoAction(_ sender: Any) {
        viewModel.animateButton(button: twoOutlet)
        inputFieldOutlet.text?.append("2")
    }
    @IBAction func fiveAction(_ sender: Any) {
        viewModel.animateButton(button: fiveOutlet)
        inputFieldOutlet.text?.append("5")
    }
    @IBAction func sixAction(_ sender: Any) {
        viewModel.animateButton(button: sixOutlet)
        inputFieldOutlet.text?.append("6")
    }
    @IBAction func divideAction(_ sender: Any) {
        viewModel.animateButton(button: divideOutlet)
        if (!viewModel.isLastOperator(field: inputFieldOutlet) && inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.append("/")
        }
    }
    @IBAction func eightAction(_ sender: Any) {
        viewModel.animateButton(button: eightOutlet)
        inputFieldOutlet.text?.append("8")
    }
    @IBAction func nineAction(_ sender: Any) {
        viewModel.animateButton(button: nineOutlet)
        inputFieldOutlet.text?.append("9")
    }
    @IBAction func deleteAction(_ sender: Any) {
        viewModel.animateButton(button: deleteOutlet)
        if (inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.removeLast()
        }
    }
    @IBAction func sevenAction(_ sender: Any) {
        viewModel.animateButton(button: sevenOutlet)
        inputFieldOutlet.text?.append("7")
    }
    @IBAction func fourAction(_ sender: Any) {
        viewModel.animateButton(button: fourOutlet)
        inputFieldOutlet.text?.append("4")
    }
    @IBAction func minusAction(_ sender: Any) {
        viewModel.animateButton(button: minusOutlet)
        if (!viewModel.isLastOperator(field: inputFieldOutlet)) {
            inputFieldOutlet.text?.append("-")
        }
    }
    @IBAction func multiplyAction(_ sender: Any) {
        viewModel.animateButton(button: multiplyOutlet)
        if (!viewModel.isLastOperator(field: inputFieldOutlet) && inputFieldOutlet.text?.count != 0) {
            inputFieldOutlet.text?.append("*")
        }
    }
    @IBAction func equalAction(_ sender: Any) {
        viewModel.animateButton(button: equalOutlet)
        if(!isError) {
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
                isError = true
            } catch CalculationError.lastSymbolOperator {
                inputFieldOutlet.text = "Operator can't be last"
                isError = true
            } catch CalculationError.invalidExpression {
                inputFieldOutlet.text = "Incorrect input"
                isError = true
            } catch {
                inputFieldOutlet.text = "Unknown error"
                isError = true
            }
        }
    }
    @IBAction func plusAction(_ sender: Any) {
        viewModel.animateButton(button: plusOutlet)
        if (!viewModel.isLastOperator(field: inputFieldOutlet)) {
            inputFieldOutlet.text?.append("+")
        }
    }
    @IBAction func commaAction(_ sender: Any) {
        viewModel.animateButton(button: commaOutlet)
        if (!viewModel.isLastDot(field: inputFieldOutlet) && inputFieldOutlet.text?.count != 0){
            let components = inputFieldOutlet.text?.split(whereSeparator: { "+-*/".contains($0) })
            if let lastComponent = components?.last, lastComponent.contains(".") {
                return
            }
            inputFieldOutlet.text?.append(".")
        }
    }
    @IBAction func zeroAction(_ sender: Any) {
        viewModel.animateButton(button: zeroOutlet)
        inputFieldOutlet.text?.append("0")
    }
    @IBAction func threeAction(_ sender: Any) {
        viewModel.animateButton(button: threeOutlet)
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
    
    func validateInput() throws {
        if viewModel.isLastDot(field: inputFieldOutlet) {
            throw CalculationError.lastSymbolDot
        }
        
        if viewModel.isLastOperator(field: inputFieldOutlet) {
            throw CalculationError.lastSymbolOperator
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

class ViewModel {
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
}
