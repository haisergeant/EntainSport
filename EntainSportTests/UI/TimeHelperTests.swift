//
//  TimeHelperTests.swift
//  EntainSportTests
//
//  Created by Hai Le on 25/10/2023.
//

import XCTest
@testable import EntainSport

final class TimeHelperTests: XCTestCase {

    
    func testMoreThan5Min() {
        let current = Date()
        let next = Calendar.current.date(byAdding: .minute, value: 6, to: current)!
        
        let tuple = TimeHelper.formatTimeToValueAndColor(current: current, next: next)
        XCTAssertEqual(tuple?.timeDisplayValue, "6m")
        XCTAssertEqual(tuple?.timeColor, .neutralLight)
    }
    
    func testLessThan5Min() {
        let current = Date()
        var next = Calendar.current.date(byAdding: .minute, value: 4, to: current)!
        next = Calendar.current.date(byAdding: .second, value: 6, to: next)!
        
        let tuple = TimeHelper.formatTimeToValueAndColor(current: current, next: next)
        XCTAssertEqual(tuple?.timeDisplayValue, "4m 6s")
        XCTAssertEqual(tuple?.timeColor, .secondary2)
    }
    
    func testLessThan1Min() {
        let current = Date()
        let next = Calendar.current.date(byAdding: .second, value: 48, to: current)!
        
        let tuple = TimeHelper.formatTimeToValueAndColor(current: current, next: next)
        XCTAssertEqual(tuple?.timeDisplayValue, "48s")
        XCTAssertEqual(tuple?.timeColor, .secondary2)
    }
    
    func testAfterEventStart() {
        let current = Date()
        let next = Calendar.current.date(byAdding: .second, value: -48, to: current)!
        
        let tuple = TimeHelper.formatTimeToValueAndColor(current: current, next: next)
        XCTAssertEqual(tuple?.timeDisplayValue, "-48s")
        XCTAssertEqual(tuple?.timeColor, .error)
    }
    
    func testExpiredEvent() {
        let current = Date()
        let next = Calendar.current.date(byAdding: .second, value: -61, to: current)!
        
        let tuple = TimeHelper.formatTimeToValueAndColor(current: current, next: next)
        XCTAssertNil(tuple)
    }
}
