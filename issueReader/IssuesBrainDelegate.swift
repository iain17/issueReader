//
//  IssuesBrainDelegate.swift
//  issueReader
//
//  Created by Iain Munro on 09/03/2018.
//  Copyright © 2018 Iain Munro. All rights reserved.
//

import Foundation

protocol IssuesBrainDelegate: class {
    func calculationInitialized()
    func calculationError(_ msg: String)
    func calculationCompleted()
}
