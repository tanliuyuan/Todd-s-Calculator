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
    @IBOutlet weak var display: UITextField!
    @IBOutlet weak var displayContainerView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var operatorButtons: [UIButton]!
    @IBOutlet weak var equalsButton: UIButton!
    @IBOutlet weak var acButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var calculator = Calculator()
    
    // Handles when a button is pressed.
    @IBAction func buttonHandler(sender: UIButton) {
        if let expression = calculator.verifyInput(sender.currentTitle!, currentExpression: display.text!) {
            updateDisplay(expression)
        }
    }
        
    @IBAction func calculate() {
        calculator.convertToRPN()
        if let result = calculator.evaluate() {
            display.text = "\(result)"
        }
        calculator.clearExpression()
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
        
        displayContainerView.backgroundColor = UIColor.lightGrayColor()
        
        buttonContainerView.backgroundColor = UIColor.clearColor()
        
        for button in buttons {
            button.backgroundColor = UIColor.clearColor()
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        for button in digitButtons {
            button.backgroundColor = UIColor.lightGrayColor()
        }
        
        for button in operatorButtons {
            button.backgroundColor = UIColor.brownColor()
        }
        
        deleteButton.backgroundColor = UIColor.blueColor()
        
        equalsButton.backgroundColor = UIColor.orangeColor()
        
        acButton.backgroundColor = UIColor.redColor()
        
        //calculator.convertToRPN("3.14+4×2÷(1-5)^2^3")
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
