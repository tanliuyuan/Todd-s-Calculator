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
    
    // Runs when an operand or operator button is pressed
    @IBAction func buttonHandler(sender: UIButton) {
        if let expression = calculator.verifyInput(sender.currentTitle!, currentExpression: display.text!) {
            updateDisplay(expression)
        }
    }
    
    // Runs when the "=" button is pressed
    @IBAction func calculate() {
        calculator.convertToRPN()
        if let result = calculator.evaluate() {
            if result % 1 == 0 {
                display.text = "\(Int(result))"
            } else {
                display.text = "\(result)"
            }
            // Easter Egg for Valentine's Day ;)
            if result == 2.14 || result == 214 {
                // Rosy red color scheme
                displayContainerView.backgroundColor = UIColor(red: 0.976, green: 0.973, blue: 0.973, alpha: 0.8)
                
                for button in digitButtons {
                    button.backgroundColor = UIColor(red: 0.98, green: 0.749, blue: 0.78, alpha: 1)
                }
                
                for button in operatorButtons {
                    button.backgroundColor = UIColor(red:0.941, green:0.443, blue:0.525, alpha:1)
                }
                
                deleteButton.backgroundColor = UIColor(red:0.941, green:0.443, blue:0.525, alpha:1)
                
                equalsButton.backgroundColor = UIColor(red: 0.922, green: 0.314, blue: 0.404, alpha: 1)
                
                acButton.backgroundColor = UIColor(red: 0.792, green: 0.067, blue: 0.102, alpha: 1)
            }
        } else {
            display.text = "Error: Unable to evaluate expression"
        }
        calculator.clearExpression()
    }
    
    // Runs when the delete button is pressed
    @IBAction func delete() {
        if let newExpression = calculator.delete() {
            display.text = newExpression
        } else {
            display.text = "0"
        }
    }
    
    // Runs when the AC button is pressed
    @IBAction func clear() {
        calculator.clearExpression()
        display.text = "0"
    }
    
    func updateDisplay(expression: String) {
        display.text = expression
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable user interaction with the display
        display.userInteractionEnabled = false
        
        // Set up button borders/round corners/etc.
        for button in buttons {
            button.layer.cornerRadius = 1
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
        }
        
        // Set up color scheme
        displayContainerView.backgroundColor = UIColor(red: 0.976, green: 0.973, blue: 0.973, alpha: 0.8)
        
        for button in digitButtons {
            button.backgroundColor = UIColor(red: 0.925, green: 0.898, blue: 0.808, alpha: 1)
        }
        
        for button in operatorButtons {
            button.backgroundColor = UIColor(red: 0.467, green: 0.31, blue: 0.22, alpha: 0.3)
        }
        
        deleteButton.backgroundColor = UIColor(red: 0.467, green: 0.31, blue: 0.22, alpha: 0.3)
        
        equalsButton.backgroundColor = UIColor(red: 0.773, green: 0.878, blue: 0.863, alpha: 1)
        
        acButton.backgroundColor = UIColor(red: 0.878, green: 0.557, blue: 0.475, alpha: 1)
        
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
