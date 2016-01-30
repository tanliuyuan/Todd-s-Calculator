//
//  CalculatorModel.swift
//  ToddsCalculator
//
//  Created by Liuyuan Tan on 1/29/16.
//  Copyright © 2016 Liuyuan "Todd" Tan. All rights reserved.
//

import Foundation

class CalculatorModel
{
    // Defines oprands and operations
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    // Stack of operands and operations
    private var opStack = [Op]()
    
    // A String value for keeping track of the current number, which the user is entering in a digit-by-digit manner
    var operandString = String()
    
    // Dictionary of operations and their associated symbol
    private var operations = [String:Op]()
    
    init() {
        operations["×"] = Op.BinaryOperation("×", *)
        operations["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        operations["+"] = Op.BinaryOperation("+", +)
        operations["-"] = Op.BinaryOperation("-") {$1 - $0}
        operations["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    // Append digit to the operandString
    func appendDigit(digit: String) {
        operandString += digit
    }
    
    private func evaluate(opStack: [Op]) -> (result: Double?, remainingOps: [Op]){
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
    }
    
    // Convert the current operandString into Double and push into opStack as an operand
    func pushOperand() {
        if let operand = Double(self.operandString) {
            opStack.append(Op.Operand(operand))
            self.operandString = String()
        }
        print("Operand: \(self.operandString) pushed in opStack.")
        print("Current opStack:")
        dump(opStack)
    }
    
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