//
//  CategoryPickerViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/29/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    
    
    var selectedCategoryName = ""
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store"]
    
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<categories.count {
            if categories[i] == selectedCategoryName {
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
            }
            
        }
    }
    
     // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "Cell",
                for: indexPath)
            
            let categoryName = categories[indexPath.row]
            
            cell.textLabel!.text = categoryName
            
            if categoryName == selectedCategoryName { cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
                
            }
            return cell
            
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
                
            }
            if let oldCell = tableView.cellForRow( at: selectedIndexPath) {
                oldCell.accessoryType = .none
                
            }
            
            selectedIndexPath = indexPath
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectedCategoryName = categories[indexPath.row]
                
            }
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
