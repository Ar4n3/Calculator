//
//  BrainTests.swift
//  Calculator
//
//  Created by Enara Lopez Otaegui on 6/5/17.
//  Copyright © 2017 Enara Lopez Otaegi. All rights reserved.
//

import XCTest
@testable import Calculator

class BrainTests: XCTestCase {
    var brain = CalculatorBrain()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetOperandWillSetAcumulatorWhenOperationIsNil() {
        brain.setOperand(2)
        XCTAssertTrue(brain.result == 2)
    }
    
    func testSetOperandWillSetOperandWhenOperationIsNotNil() {
        brain.performOperation("x")
        brain.setOperand(3)
        XCTAssertTrue(brain.getOperand == 3)
    }
    
    func testSetOperandWillNotSetAcumulatorWhenOperationIsNotNil() {
        brain.performOperation("x")
        brain.setOperand(3)
        XCTAssertNil(brain.result)
    }
    
    func testSetOperandWillNotSetOperation() {
        brain.setOperand(2)
        XCTAssertTrue(brain.operationSymbol == nil)
    }
    
    func testSetOperandWillNotSetOperand() {
        brain.setOperand(2)
        XCTAssertTrue(brain.getOperand == nil)
    }
    
    func testPerformOperationWillSetOperation() {
        brain.performOperation("x")
        XCTAssertTrue(brain.operationSymbol == "x")
    }
    
    func testSetOperandWillNotChangeAccumulator() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.setOperand(3)
        XCTAssertTrue(brain.result == 2)
    }
    
    func testPerformOperationEqualWillChangeAccumulator() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertTrue(brain.result == 6)
    }
    
    func testPerformOperationAnyWillChangeAccumulator() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.setOperand(3)
        brain.performOperation("-")
        XCTAssertTrue(brain.result == 6.0)
    }
    
    func testPerformOperationUnitaryWillChangeAccumulator() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.setOperand(3)
        brain.performOperation("%")
        XCTAssertTrue(brain.result == 0.03)
    }
    
    func testOperationWithNoOperandWillNotChangeAccumulator() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.performOperation("x")
        brain.performOperation("x")
        XCTAssertTrue(brain.result == 2)
    }
    
    func testEqualWithNoOperandWillChangeAccumulator() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.performOperation("=")
        brain.performOperation("=")
        XCTAssertTrue(brain.result == 8)
    }
    
    func testChangingOperationWillPerformLastOperation() {
        brain.setOperand(2)
        brain.performOperation("x")
        brain.performOperation("-")
        brain.performOperation("=")
        brain.performOperation("=")
        XCTAssertTrue(brain.result == -2)
    }
    
    func testOperationWithoutAccumulatorReturnsCorrectAnswer() {
        brain.performOperation("-")
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertTrue(brain.result == -9)
    }
    
    func testPerformOperationWithoutOperandReturnsAccumulator() {
        brain.setOperand(9)
        brain.performOperation("-")
        brain.performOperation("=")
        XCTAssertTrue(brain.result == 0)
    }
    
    func testMoreThanOneOperationReturnsCorrectAccumulator() {
        brain.setOperand(9)
        brain.performOperation("-")
        brain.setOperand(1)
        brain.performOperation("+")
        brain.setOperand(2)
        brain.performOperation("=")
        XCTAssertTrue(brain.result == 10)
    }
    
    func testBugWhenSettingOperatorBeforeAcumulator() {
        brain.performOperation("x")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("AC")
        brain.setOperand(9)
        brain.performOperation("x")
        XCTAssertTrue(brain.result == 9)
    }
    
    func testBugWhenSettingOperatorBeforeAcumulatorWithoutAC() {
        brain.performOperation("x")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.setOperand(9)
        brain.performOperation("x")
        XCTAssertTrue(brain.result == 9)
    }
    
    func testFailingTest {
        XCTAssertTrue(false)
    }
    
}
