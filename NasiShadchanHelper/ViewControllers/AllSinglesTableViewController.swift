//
//  AllSinglesTableViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/28/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class AllSinglesTableViewController: UITableViewController {

    let cellIdentifier = "AllSinglesCellID"
    var coreDataStack: CoreDataStack!
    
    var allSingles =  [SingleGirl]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
        let managedContext = coreDataStack.mainContext
        allSingles = try! managedContext.fetch(request)

         self.clearsSelectionOnViewWillAppear = false

    }
    
   // MARK: - Table view data source

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
       return allSingles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let currentSingle = allSingles[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1):" + " " + currentSingle.lastName + " " + currentSingle.firstName
        
         print("the current singles is \(currentSingle.lastName)")

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
