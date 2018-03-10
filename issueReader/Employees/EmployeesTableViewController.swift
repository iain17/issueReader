//
//  EmployeesTableViewController.swift
//  issueReader
//
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
    
    func calculationError(_ msg: String) {
        let ac = UIAlertController(title: "Loading error", message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func calculationInitialized() {
        self.refreshControl?.beginRefreshing()
    }
    
    func calculationCompleted() {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
