//
//  CalculatorModel.swift
//  ToddsCalculator
//
//  Created by Liuyuan Tan on 1/29/16.
//  Copyright © 2016 Liuyuan "Todd" Tan. All rights reserved.
//

import Foundation

class Calculator
{
    // Defines oprands and operations
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    // A String value for keeping track of the current mathematical expression
    private var expression = String()
    // Last input character to the mathematical expression string
    private var lastInput = String()
    // Boolean value indicating if user is in the middle of entering the expression
    private var isEnteringExpression = false
    // Maximum characters allowed in the expression
    private let maxLengthOfExpression = 16
    // Length (the number of characters) of the expression
    private var lengthOfExpression = 0
    // Number of open parentheses (for matching close parentheses)
    private var numOpenParentheses = 0
    // Boolean value indicating if there's operand between parentheses
    private var operandBetweenParentheses = false
    
    // Stack of operands and operations
    private var opStack = [Op]()
    
    // Dictionary of operations and their associated symbol
    private var operations = [String:Op]()
    
    init() {
        operations["×"] = Op.BinaryOperation("×", *)
        operations["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        operations["+"] = Op.BinaryOperation("+", +)
        operations["-"] = Op.BinaryOperation("-") {$1 - $0}
        operations["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    // Takes in the current expression on display and the next input (the digit/simbol on the buttons) the user is trying to append to the expression. Decideds if the input is legit (e.g. you can't start the expression with a "÷"). If input is legit, function appends the input to the current expression, and returns the updated expression. Otherwise returns nil.
    func verifyInput(pendingInput: String, currentExpression: String) -> String? {
        var isLegit = false
        var expression: String?
        legit: if lengthOfExpression < maxLengthOfExpression{
            if !isEnteringExpression {
                switch pendingInput {
                case "(":
                    numOpenParentheses++
                    isLegit = true
                    break legit
                case ".":
                    lastInput = "0."
                    isLegit = true
                    break legit
                default:
                    if Double(pendingInput) != nil {
                        isLegit = true
                        break legit
                    }
                }
            } else {
                switch pendingInput {
                case "(":
                    numOpenParentheses++
                    isLegit = true
                    break legit
                case ")":
                    if numOpenParentheses > 0 && operandBetweenParentheses && Double(lastInput) != nil {
                        numOpenParentheses--
                        operandBetweenParentheses = false
                        isLegit = true
                        break legit
                    } else {
                        break legit
                    }
                case ".":
                    if Double(lastInput) != nil && lastInput != "0." && lastInput != "." {
                        isLegit = true
                        break legit
                    }
                default:
                    if Double(pendingInput) != nil {
                        if numOpenParentheses > 0 {
                            operandBetweenParentheses = true
                        }
                        isLegit = true
                        break legit
                    } else {
                        if Double(lastInput) != nil || lastInput == ")" {
                            isLegit = true
                            break legit
                        }
                    }
                }
            }
        }
        if isLegit {
            if !isEnteringExpression {
                isEnteringExpression = true
                lastInput = pendingInput
                expression = lastInput
                self.expression = expression!
                lengthOfExpression = expression!.characters.count
            } else {
                lastInput = pendingInput
                expression = currentExpression + lastInput
                self.expression = expression!
                lengthOfExpression = expression!.characters.count
            }
        }
        return expression
    }
    
    // Delete last character in expression
    func delete() -> String? {
        if lengthOfExpression == 1 {
            expression = String()
            lengthOfExpression--
            isEnteringExpression = false
            return "0"
        } else if lengthOfExpression > 1{
            expression = String(expression.characters.dropLast())
            lengthOfExpression--
            print(lengthOfExpression)
            return expression
        } else {
            return nil
        }
    }
    
    // Clear expression
    func clearExpression() {
        isEnteringExpression = false
        expression = String()
    }
    
    /*// Append digit to the operandString
    func appendDigit(digit: String) {
        operandString += digit
    }*/
    
    /*private func evaluate(opStack: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !opStack.isEmpty {
            var remainingOps = opStack
            var tempOperandStack = Array<Op>()
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(_):
                print("Found operand: \(op)")
                tempOperandStack.append(op)
                return (evaluate(remainingOps))
            case .UnaryOperation(_, let operation): break
                /*print("Found unary operation: \(op)")
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand),  operandEvaluation.remainingOps)
                }*/
            case .BinaryOperation(_, let operation): break
                /*print("Found binary operation: \(op)")
                if let operand1 = tempOperandStack.removeLast() {
                    let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.result {
                        return (operation(operand1, operand2), remainingOps)
                    }
                }*/
            }
        }
        return (nil, opStack)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }*/
    
    /*// Convert the current operandString into Double and push into opStack as an operand
    func pushOperand() {
        if let operand = Double(self.operandString) {
            opStack.append(Op.Operand(operand))
            self.operandString = String()
        }
        print("Operand: \(self.operandString) pushed in opStack.")
        print("Current opStack:")
        dump(opStack)
    }*/
    
    // Determine if the symbol is in the list of defined operations (see init()). If so, push the operation symbol to opStack.
    func pushSymbol(symbol: String) {
        if let operation = operations[symbol] {
            opStack.append(operation)
            print("Symbol: \(symbol) pushed in opStack.")
            print("Current opStack:")
            dump(opStack)
        } else {
            print("Unknown symbol.")
        }
    }
}