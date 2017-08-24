//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Enara Lopez Otaegi on 5/4/17.
//  Copyright © 2017 Enara Lopez Otaegi. All rights reserved.
//

import Foundation

func percentage(_ operand: Double) -> Double {
    return operand / 100
}

func sum(_ operand: Double, with mOperator: Double) -> Double {
    return operand + mOperator
}

func substract(_ operand: Double, with mOperator: Double) -> Double {
    return operand - mOperator
}

func divide(_ operand:Double, with mOperator: Double) -> Double {
    return operand / mOperator
}

func sign(_ operand:Double) -> Double {
    return -operand
}

func multiply(_ operand: Double, with mOperator: Double) -> Double {
    return operand * mOperator
}

func clear() -> Double {
    return 0
}

struct CalculatorBrain {
    private var acumulator: Double?
    private var operand: Double?
    private var operation: String?
    private var isPendingOperation = false
    
    private enum Operation {
        case clearOperation(() -> Double)
        case binaryOperation((Double, Double) -> Double)
        case unaryOperation((Double) -> Double)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "/"     : Operation.binaryOperation(divide),
        "+/-"   : Operation.unaryOperation(sign),
        "x"     : Operation.binaryOperation(multiply),
        "AC"    : Operation.clearOperation(clear),
        "-"     : Operation.binaryOperation(substract),
        "+"     : Operation.binaryOperation(sum),
        "%"     : Operation.unaryOperation(percentage),
    ]
    
    mutating func setOperand(_ mOperand: Double) {
        if operation == nil {
            acumulator = mOperand
            operand = nil
        } else {
            operand = mOperand
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let hOperation = operations[symbol] {
            switch hOperation {
            case .unaryOperation(let function):
                if operand != nil {
                    acumulator = function(operand!)
                } else if let mAcumulator = acumulator {
                    acumulator = function(mAcumulator)
                }
                resetVars()
            case .binaryOperation(let function):
                if isPendingOperation && operand != nil && operation != nil {
                    isPendingOperation = false
                    performOperation(operation!)
                    operation = symbol
                } else {
                    if let mOperand = operand {
                        if let mAcumulator = acumulator {
                            acumulator = function(mAcumulator, mOperand)
                        } else {
                            acumulator = function(0, mOperand)
                            operation = nil
                        }
                    } else {
                        isPendingOperation = true
                        operation = symbol
                    }
                }
            case .clearOperation(let function):
                acumulator = function()
                resetVars()
            }
        } else if symbol == "=" && operation != nil {
            isPendingOperation = false
            if (operand == nil) {
                operand = acumulator!
            }
            performOperation(operation!)
        }
    }
    
    mutating private func resetVars() {
        operand = nil
        operation = nil
    }
    
    var result: Double? {
        get {
            return acumulator
        }
    }
    
    var operationSymbol: String? {
        get {
            return operation
        }
    }
    
    var getOperand: Double? {
        get {
            return operand
        }
    }
    
}
