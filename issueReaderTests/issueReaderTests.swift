//
//  issueReaderTests.swift
//  issueReaderTests
//
//  Created by Iain Munro on 08/03/2018.
//  Copyright © 2018 Iain Munro. All rights reserved.
//

import XCTest
import CSV
@testable import issueReader

class Subject: IssuesBrainDelegate {
    var calculationInitializedCalled = false
    var errorMsg = ""
    var calculationCompletedCalled = false
    
    func calculationInitialized() {
        calculationInitializedCalled = true
    }
    func calculationError(_ msg: String) {
        errorMsg = msg
    }
    func calculationCompleted() {
        calculationCompletedCalled = true
    }
}

class IssuesBrainTests: XCTestCase {
    
    var brain: IssuesBrain?
    var subject: Subject?
    
    override func setUp() {
        super.setUp()
        subject = Subject()
        self.brain = IssuesBrain(delegate: subject!)
    }
    
    func testParseSuccess() {
        let csvString = "\"First name\",\"Sur name\",\"Issue count\",\"Date of birth\"\n\"Theo\",\"Jansen\",5,\"1978-01-02T00:00:00\""
        let csv = try! CSVReader(string: csvString)
        brain?.run(csvReader: csv)
        XCTAssertTrue(subject!.calculationInitializedCalled)
        sleep(2)
        XCTAssertEqual(subject?.errorMsg, "")
        XCTAssertTrue(subject!.calculationCompletedCalled)
        XCTAssertTrue(brain?.employees.count == 1)
        XCTAssertEqual(brain?.employees[0].firstName, "Theo")
        XCTAssertEqual(brain?.employees[0].lastName, "Jansen")
        XCTAssertEqual(brain?.employees[0].numIssues, 5)
        XCTAssertEqual(brain?.employees[0].birthday, Date(timeIntervalSince1970: 252547200))
        XCTAssertTrue(subject!.calculationCompletedCalled)
    }
    
    func testParseFail() {
        let csvString = "foo,bar\n1,2"
        let csv = try! CSVReader(string: csvString)
        brain?.run(csvReader: csv)
        XCTAssertTrue(subject!.calculationInitializedCalled)
        sleep(2)
        XCTAssertEqual(subject?.errorMsg, "Parse error: The operation couldn’t be completed. (issueReader.IssuesBrain.errors error 0.)")
        XCTAssertTrue(subject!.calculationCompletedCalled)
    }
    
}
