//
//  EmployeeTableViewCell.swift
//  issueReader
//  Cell of the employeesTableView that shows a single employee, extending on TDBadgedCell to easily show the number of issues.
//  Created by Iain Munro on 09/03/2018.
//  Copyright © 2018 Iain Munro. All rights reserved.
//

import UIKit
import TDBadgedCell

class EmployeeTableViewCell: TDBadgedCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        self.dateFormatter.dateStyle = DateFormatter.Style.long
        self.dateFormatter.timeStyle = .none
    }
    
    public var employee:Employee? {
        didSet {
            if let value = employee {
                self.name.text = "\(value.firstName) \(value.lastName)"
                self.badgeString = String(describing: value.issue)
                self.birthday.text = self.dateFormatter.string(from: value.birthday)
            }
        }
    }
}
