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
        self.delegate?.calculationInitialized()
        DispatchQueue.main.async {
            self.parseCSV(stream)
            self.delegate?.calculationCompleted()
        }
    }
    
    private func parseCSV(_ stream: InputStream) {
        self.employees = []
        do {
            let csv = try CSVReader(stream: stream)
            csv.next()
            while let row = csv.next() {
                guard let date = dateFormatter.date(from: row[3]) else {
                    continue
                }
                guard let issues = Int(row[2]) else {
                    continue
                }
                let employee = Employee(
                    firstName: row[0],
                    lastName: row[1],
                    birthday: date,
                    issue: issues
                )
                self.employees.append(employee)
            }
        } catch let exception {
            print(exception)
            self.delegate?.calculationError("Failed to parse CSV file")
        }
    }
    
}
