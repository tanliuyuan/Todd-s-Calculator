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
    /***************************************/
    // Private classes
    private class Operation {
        var symbol: String
        var precedence: Int
        var leftAssociative: Bool
        
        init() {
            symbol = ""
            precedence = 0
            leftAssociative = true
        }
        
        init(symbol: String, precedence: Int, leftAssociative: Bool) {
            self.symbol = symbol
            self.precedence = precedence
            self.leftAssociative = leftAssociative
        }
    }
    
    private class UnaryOperation: Operation {
        var operation: Double -> Double = {_ in return 0}
        
        init(symbol: String, precedence: Int, leftAssociative: Bool, operation: Double -> Double) {
            super.init()
            self.symbol = symbol
            self.precedence = precedence
            self.leftAssociative = leftAssociative
            self.operation = operation
        }
    }
    
    private class BinaryOperation: Operation {
        var operation: (Double, Double) -> Double = {_,_ in return 0}
        
        init(symbol: String, precedence: Int, leftAssociative: Bool, operation: (Double, Double) -> Double) {
            super.init()
            self.symbol = symbol
            self.precedence = precedence
            self.leftAssociative = leftAssociative
            self.operation = operation
        }
    }
    // End private classes
    /***************************************/
    
    
    /***************************************/
    // Private variables
    // Defines oprands and operations
    private enum Op: CustomStringConvertible {
        case OperandCase(Double)
        case OperationCase(Operation)
        
        var description: String {
            switch self {
            case .OperandCase(let operand):
                return "\(operand)"
            case .OperationCase(let operation):
                return operation.symbol
            }
        }
    }
    
    // A String value for keeping track of the current mathematical expression
    private var expression = String()
    // Last input character to the mathematical expression string
    private var lastInput = String()
    // Maximum characters allowed in the expression
    private let maxLengthOfExpression = 32
    // Length (the number of characters) of the expression
    private var lengthOfExpression = 0
    // Number of open parentheses (for matching close parentheses)
    private var numOpenParentheses = 0
    // Boolean value indicating if there's operand between parentheses
    private var operandBetweenParentheses = false
    // Boolean value indicating whether there's a decimal point in the number being entered (there can't be more than one decimal point in a number)
    private var decimalPoint = false
    // Boolean value indicating if user is in the middle of entering the expression
    private var isEnteringExpression = false
    
    // Stack of operands and operations
    private var opStack = [Op]()
    
    // Dictionary of operations and their associated symbol
    private var knownOps = [String:Op]()
    
    // End private variables
    /***************************************/
    
    // Initialize known operations and operands
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.OperationCase(BinaryOperation(symbol: "×", precedence: 3, leftAssociative: true, operation: *)))
        learnOp(Op.OperationCase(BinaryOperation(symbol: "÷", precedence: 3, leftAssociative: true) {$1 / $0}))
        learnOp(Op.OperationCase(BinaryOperation(symbol: "+", precedence: 2, leftAssociative: true, operation: +)))
        learnOp(Op.OperationCase(BinaryOperation(symbol: "-", precedence: 2, leftAssociative: true) {$1 - $0}))
        learnOp(Op.OperationCase(BinaryOperation(symbol: "^", precedence: 4, leftAssociative: false) {pow($0, $1)}))
        learnOp(Op.OperationCase(UnaryOperation(symbol: "√", precedence: 4, leftAssociative: false, operation: sqrt)))
        learnOp(Op.OperationCase(Operation(symbol: "(", precedence: 5, leftAssociative: true)))
        learnOp(Op.OperationCase(Operation(symbol: ")", precedence: 5, leftAssociative: true)))
    }
    
    /***************************************/
    // Private functions
     
    // Convert a mathematical expression from Infix notation to Reverse Polish notation (RPN) using Shunting-Yard Algorithm
    // See https://en.wikipedia.org/wiki/Infix_notation for Infix notation
    // See https://en.wikipedia.org/wiki/Reverse_Polish_notation for RPN
    // See https://en.wikipedia.org/wiki/Shunting-yard_algorithm for Shunting-Yard Algorithm
    private func convertToRPN(infixNotation: String) -> [Op] {
        
        var RPNStack = [Op]()
        var operandString = ""
        var operationStack = [Operation]()
        let leftParenthesis = Operation(symbol: "(", precedence: 5, leftAssociative: true)
        let rightParenthesis = Operation(symbol: ")", precedence: 5, leftAssociative: true)
        
        // read characters from the Infix notation string
        for char in infixNotation.characters {
            if Double(String(char)) != nil || char == "." {
                operandString.append(char)
            } else {
                if let operand = Double(operandString){
                    RPNStack.append(Op.OperandCase(operand))
                    operandString = ""
                }
                if char != "(" && char != ")" {
                    if let operation = knownOps[String(char)] {
                        switch operation {
                        case .OperationCase(let currentOperation):
                            while !operationStack.isEmpty {
                                if let lastOperationInStack = operationStack.last {
                                    if lastOperationInStack != leftParenthesis {
                                        if (currentOperation.leftAssociative == true && currentOperation.precedence <= lastOperationInStack.precedence) || (currentOperation.leftAssociative == false && currentOperation.precedence < lastOperationInStack.precedence){
                                            RPNStack.append(Op.OperationCase(operationStack.removeLast()))
                                        } else {
                                            break
                                        }
                                    } else {
                                        break
                                    }
                                }
                            }
                            operationStack.append(currentOperation)
                        default: break
                        }
                    }
                } else if char == "(" {
                    operationStack.append(leftParenthesis)
                } else if char == ")" {
                    while !operationStack.isEmpty {
                        if let operation = operationStack.last {
                            if operation != leftParenthesis {
                                RPNStack.append(Op.OperationCase(operationStack.removeLast()))
                            } else {
                                operationStack.removeLast()
                                break
                            }
                        }
                    }
                }
            }
        }
        // append the last operand to the RPN stack
        if let operand = Double(operandString){
            RPNStack.append(Op.OperandCase(operand))
            operandString = ""
        }
        
        // when there's no characters left to read in the Infix notation string, pop all non-parenthesis operations from operationStack (if there was parentheses left in the stack, we have mismatched parentheses in the input)
        while !operationStack.isEmpty {
            let lastOperationInStack = operationStack.removeLast()
            if lastOperationInStack != leftParenthesis && lastOperationInStack != rightParenthesis {
                RPNStack.append(Op.OperationCase(lastOperationInStack))
            }
        }
        
        return RPNStack
    }
    
    // Evaluate the given RPN stack
    private func evaluate(opStack: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !opStack.isEmpty {
            var remainingOps = opStack
            let op = remainingOps.removeLast()
            switch op {
            case .OperandCase(let operand):
                return (operand, remainingOps)
            case .OperationCase(let operation):
                if let unaryOperation = operation as? UnaryOperation {
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (unaryOperation.operation(operand),  operandEvaluation.remainingOps)
                    }
                } else if let binaryOperation = operation as? BinaryOperation {
                    let operand1Evaluation = evaluate(remainingOps)
                    if let operand1 = operand1Evaluation.result{
                        let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                        if let operand2 = operand2Evaluation.result {
                            return (binaryOperation.operation(operand1, operand2), operand2Evaluation.remainingOps)
                        }
                    }
                }
            }
        }
        return (nil, opStack)
    }
    
    // End private functions
    /***************************************/
    
    
    /***************************************/
    // APIs
    // Takes in a current expression string and the next input (the digit/simbol on the buttons) the user is trying to append to the expression. Decideds if the input is legit (e.g. you can't start the expression with a "÷"). If input is legit, function appends the input to the current expression, and returns the updated expression. Otherwise returns nil.
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
                case "√":
                    isLegit = true
                    break legit
                case ".":
                    lastInput = "0."
                    decimalPoint = true
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
                    if Double(lastInput) == nil && lastInput != "(" && lastInput != "." {
                        numOpenParentheses++
                        isLegit = true
                        break legit
                    }
                case ")":
                    if numOpenParentheses > 0 && operandBetweenParentheses && (Double(lastInput) != nil || lastInput == ")"){
                        numOpenParentheses--
                        operandBetweenParentheses = false
                        if decimalPoint {
                            decimalPoint = false
                        }
                        isLegit = true
                        break legit
                    } else {
                        break legit
                    }
                case "√":
                    if Double(lastInput) == nil && lastInput != ")" && lastInput != "." {
                        isLegit = true
                        break legit
                    }
                case ".":
                    if Double(lastInput) != nil && lastInput != "0." && decimalPoint == false {
                        decimalPoint = true
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
                            if decimalPoint {
                                decimalPoint = false
                            }
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
                expression = lastInput
                lastInput = pendingInput
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
    
    func convertToRPN() {
        opStack = convertToRPN(expression)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    // Indicate whether user is in the middle of entering an expression
    func enteringExpression() -> Bool {
        return isEnteringExpression
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
            return expression
        } else {
            return nil
        }
    }
    
    // Clear expression
    func clearExpression() {
        isEnteringExpression = false
        decimalPoint = false
        numOpenParentheses = 0
        operandBetweenParentheses = false
        lengthOfExpression = 0
        lastInput = String()
        expression = String()
    }
    // End APIs
    /***************************************/
    
    
    // Print the operands and operators in a given stack of Op. Used for testing.
    private func printOpStack(stack: [Op]) {
        print("************************")
        for op in stack {
            switch op {
            case .OperandCase(let operand):
                print(operand)
            case .OperationCase(let operation):
                print(operation.symbol)
            }
        }
        print("************************")
    }
}


// Overload != and == operators for Operation class
private func != (left: Calculator.Operation, right: Calculator.Operation) -> Bool {
    return (left.symbol != right.symbol)
}
private func == (left: Calculator.Operation, right: Calculator.Operation) -> Bool {
    return (left.symbol == right.symbol)
}