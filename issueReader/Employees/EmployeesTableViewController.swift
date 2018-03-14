//
//  EmployeesTableViewController.swift
//  issueReader
//  Takes care of displaying the CSV data in a simple table view.
//  Created by Iain Munro on 08/03/2018.
//  Copyright © 2018 Iain Munro. All rights reserved.
//

import UIKit

class EmployeesTableViewController: UITableViewController, IssuesBrainDelegate {
    var issuesBrain: IssuesBrain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Parsing issues...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkText])
        self.issuesBrain = IssuesBrain(delegate: self)
        self.refresh(nil)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        do {
            try self.issuesBrain?.load(file: "issues", ofType: "csv")
        } catch let exception {
            calculationError("Failed to load CSV")
            print(exception)
        }
    }
    
    //Feedback back to the user if things didn't work out as expected.
    func calculationError(_ msg: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: msg, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    //Delegate function so the viewController knows when the brain has started parsing the CSV.
    func calculationInitialized() {
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
        }
    }
    
    //Delegate function that informs the viewController that the calculation was completed. Stops the refreshControl and reloads the tableView.
    func calculationCompleted() {
        DispatchQueue.global(qos: .background).async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.issuesBrain?.employees.count {
            return count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as? EmployeeTableViewCell {
            cell.employee = self.issuesBrain?.employees[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
