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
    
    var calculator = CalculatorModel()
    // Boolean value indicating if user is in the middle of entering digits
    var isEnteringDigits = false
    // Length of digits in display (9 at maximum)
    var digitsOnDisplay = 0
    
    // Handles when a digit button is pressed
    @IBAction func appendDigit(sender: UIButton) {
        if !isEnteringDigits{
            if sender.currentTitle! != "0"{
                isEnteringDigits = true
                if display.text != nil {
                    display.text! = (sender.currentTitle!)
                    digitsOnDisplay = 1
                    calculator.appendDigit(sender.currentTitle!)
                    print("Digit: \(sender.currentTitle!)")
                }
            }
        } else if digitsOnDisplay <= 9 {
            digitsOnDisplay++
            if display.text != nil {
                display.text! += (sender.currentTitle!)
                calculator.appendDigit(sender.currentTitle!)
                print("Digit: \(sender.currentTitle!)")
            }
        } else {
            print("Digit: \(sender.currentTitle!)")
            print("Number of digits exceeds limit")
        }
    }
    
    // Handles when a symbol button is pressed
    @IBAction func appendSymbol(sender: UIButton) {
        if isEnteringDigits {
            calculator.pushOperand()
            isEnteringDigits = false
            calculator.pushSymbol(sender.currentTitle!)
            print("Symbol: \(sender.currentTitle!)")
        }
    }
    
    @IBAction func calculate() {
        if isEnteringDigits {
            calculator.pushOperand()
            isEnteringDigits = false
        }
        if let result = calculator.evaluate() {
            display.text = "\(result)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable default keyboard
        display.inputView = UIInputView()
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
