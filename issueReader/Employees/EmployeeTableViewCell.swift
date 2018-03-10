//
//  EmployeeTableViewCell.swift
//  issueReader
//
//  Created by Iain Munro on 09/03/2018.
//  Copyright © 2018 Iain Munro. All rights reserved.
//

import UIKit
import TDBadgedCell

class EmployeeTableViewCell: TDBadgedCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birth: UILabel!
    
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
                self.birth.text = self.dateFormatter.string(from: value.birthday)
            }
        }
    }
    
    public func show() {
        self.badgeString = "1"
    }

}
