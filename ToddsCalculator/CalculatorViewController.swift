//
//  CalculatorViewController.swift
//  ToddsCalculator
//
//  Created by Liuyuan Tan on 1/28/16.
//  Copyright © 2016 Liuyuan "Todd" Tan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var calculatorView: UIView!
    @IBOutlet var digits: [UIButton]!
    @IBOutlet weak var display: UITextField!
    @IBOutlet weak var displayContainerView: UIView!
    
    var calculator = Calculator()
    
    // Handles when a button is pressed.
    @IBAction func buttonHandler(sender: UIButton) {
        if let expression = calculator.verifyInput(sender.currentTitle!, currentExpression: display.text!) {
            updateDisplay(expression)
        }
    }
        
    @IBAction func calculate() {
        /*if calculator.isEnteringExpression {
            calculator.pushOperand()
            isEnteringExpression = false
        }
        if let result = calculator.evaluate() {
            display.text = "\(result)"
        }*/
    }
    
    @IBAction func delete() {
        if let newExpression = calculator.delete() {
            display.text = newExpression
        } else {
            display.text = "0"
        }
    }
    
    @IBAction func clear() {
        calculator.clearExpression()
        display.text = "0"
    }
    
    func updateDisplay(expression: String) {
        display.text = expression
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable default keyboard
        display.inputView = UIInputView()
        
        calculator.convertToRPN("3.14+4×2÷(1-5)^2^3")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
