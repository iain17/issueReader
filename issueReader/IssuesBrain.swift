//
//  IssuesBrain.swift
//  issueReader
//
//  Created by Iain Munro on 09/03/2018.
//  Copyright © 2018 Iain Munro. All rights reserved.
//

import Foundation
import CSV

class IssuesBrain {
    
    enum errors: Error {
        case fileNotFound
        case ValidationError(String)
    }
    
    let dateFormatter = DateFormatter()
    weak var delegate: IssuesBrainDelegate?
    var employees: [Employee] = []
    
    init(delegate: IssuesBrainDelegate) {
        self.delegate = delegate
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    func load(file: String, ofType: String) throws {
        guard let csvPath = Bundle.main.path(forResource: file, ofType: ofType) else {
            throw errors.fileNotFound
        }
        guard let stream = InputStream(fileAtPath: csvPath) else {
            throw errors.fileNotFound
        }
        self.clear()
        let reader = try CSVReader(stream: stream)
        self.delegate?.calculationInitialized()
        DispatchQueue.main.async {
            self.parse(csvReader: reader)
            self.delegate?.calculationCompleted()
        }
    }
    
    private func clear() {
        self.employees = []
    }
    
    private func validate(row: [String]) throws -> (Date, Int) {
        if row.count != 4 {
            throw errors.ValidationError("malformed data")
        }
        guard let date = dateFormatter.date(from: row[3]) else {
            throw errors.ValidationError("failed to parse date")
        }
        guard let numIssues = Int(row[2]) else {
            throw errors.ValidationError("failed to parse number of issues")
        }
        return (date, numIssues)
    }
    
    private func parse(csvReader: CSVReader) {
        csvReader.next()//Skip header
        while let row = csvReader.next() {
            var birthday: Date
            var numIssues: Int
            do {
                (birthday, numIssues) = try validate(row: row)
            } catch let exception {
                self.delegate?.calculationError("Row \(csvReader.currentRow): \(exception.localizedDescription)")
                continue//Skip this row.
            }
            let employee = Employee(
                firstName: row[0],
                lastName: row[1],
                birthday: birthday,
                numIssues: numIssues
            )
            self.employees.append(employee)
        }
    }
    
}
