//
//  SimpleFitTests.swift
//  SimpleFitTests
//
//  Created by shuo on 2020/12/31.
//

import XCTest
@testable import SimpleFit

class SimpleFitTests: XCTestCase {

    let goalCell = GoalCell()
    let currentWeight = 60.0
    var goal = Goal()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsZeroGain() {
        
        goal.beginWeight = 70.0
        goal.endWeight = 80.0
        
        let progress = goalCell.calculateProgress(with: goal, currentWeight: currentWeight)
        
        XCTAssert(progress == 0)
    }
    
    func testIsZeroLoss() {
        
        goal.beginWeight = 50.0
        goal.endWeight = 40.0

        let progress = goalCell.calculateProgress(with: goal, currentWeight: currentWeight)
        
        XCTAssert(progress == 0)
    }
    
    func testIsNormalProgress() {
        
        goal.beginWeight = 70.0
        goal.endWeight = 50.0

        let progress = goalCell.calculateProgress(with: goal, currentWeight: currentWeight)
        
        XCTAssert(progress <= 1)
    }
    
    func testIsProgressCompleted() {
        
        goal.beginWeight = 80.0
        goal.endWeight = 70.0

        let progress = goalCell.calculateProgress(with: goal, currentWeight: currentWeight)
        
        XCTAssertFalse(progress > 1)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
