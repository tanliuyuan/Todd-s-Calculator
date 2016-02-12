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
    
    // Defines oprands and operations
    private enum Op {
        case OperandCase(Double)
        case OperationCase(Operation)
        //case Unary(UnaryOperation)
        //case Binary(BinaryOperation)
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
    private var operations = [String:Op]()
    
    init() {
        operations["×"] = Op.OperationCase(BinaryOperation(symbol: "×", precedence: 3, leftAssociative: true, operation: *))
        operations["÷"] = Op.OperationCase(BinaryOperation(symbol: "÷", precedence: 3, leftAssociative: true) {$1 / $0})
        operations["+"] = Op.OperationCase(BinaryOperation(symbol: "+", precedence: 2, leftAssociative: true, operation: +))
        operations["-"] = Op.OperationCase(BinaryOperation(symbol: "-", precedence: 2, leftAssociative: true) {$1 - $0})
        operations["^"] = Op.OperationCase(BinaryOperation(symbol: "^", precedence: 4, leftAssociative: false) {pow($0, $1)})
        operations["√"] = Op.OperationCase(UnaryOperation(symbol: "√", precedence: 4, leftAssociative: false, operation: sqrt))
        operations["("] = Op.OperationCase(Operation(symbol: "(", precedence: 5, leftAssociative: true))
        operations[")"] = Op.OperationCase(Operation(symbol: ")", precedence: 5, leftAssociative: true))
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
                    if numOpenParentheses > 0 && operandBetweenParentheses && Double(lastInput) != nil {
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
        decimalPoint = false
        numOpenParentheses = 0
        operandBetweenParentheses = false
        lengthOfExpression = 0
        lastInput = String()
        expression = String()
    }
    
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
                    print("Appending operand to RPN stack: \(operandString)")
                    RPNStack.append(Op.OperandCase(operand))
                    operandString = ""
                }
                if char != "(" && char != ")" {
                    if let operation = operations[String(char)] {
                        switch operation {
                        case .OperationCase(let currentOperation):
                            while !operationStack.isEmpty {
                                if let lastOperationInStack = operationStack.last {
                                    if lastOperationInStack != leftParenthesis {
                                        if (currentOperation.leftAssociative == true && currentOperation.precedence <= lastOperationInStack.precedence) || (currentOperation.leftAssociative == false && currentOperation.precedence < lastOperationInStack.precedence){
                                            print("Appending operator to RPN stack: \(currentOperation.symbol)")
                                            RPNStack.append(Op.OperationCase(operationStack.removeLast()))
                                        } else {
                                            break
                                        }
                                    } else {
                                        break
                                    }
                                }
                            }
                            print("Appending to operation stack: \(currentOperation.symbol)")
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
                                print("Appending operator to RPN stack: \(operation.symbol)")
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
            print("Appending operand to RPN stack: \(operandString)")
            RPNStack.append(Op.OperandCase(operand))
            operandString = ""
        }
        
        // when there's no characters left to read in the Infix notation string, pop all non-parenthesis operations from operationStack (if there was parentheses left in the stack, we have mismatched parentheses in the input)
        while !operationStack.isEmpty {
            let lastOperationInStack = operationStack.removeLast()
            if lastOperationInStack != leftParenthesis && lastOperationInStack != rightParenthesis {
                print("Appending operator to RPN stack: \(lastOperationInStack.symbol)")
                RPNStack.append(Op.OperationCase(lastOperationInStack))
            }
        }
        
        printOpStack(RPNStack)
        
        return RPNStack
    }
    
    func convertToRPN(infixNotation: String) {
        opStack = convertToRPN(infixNotation)
    }
    
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
            case .UnaryOperation(_, let operation):
                /*print("Found unary operation: \(op)")
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand),  operandEvaluation.remainingOps)
                }*/
            case .BinaryOperation(_, let operation):
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


// Overload != and == operators for Operation class
private func != (left: Calculator.Operation, right: Calculator.Operation) -> Bool {
    return (left.symbol != right.symbol)
}
private func == (left: Calculator.Operation, right: Calculator.Operation) -> Bool {
    return (left.symbol == right.symbol)
}