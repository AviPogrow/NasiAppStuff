//
//  FullTimeCollegeWorkingViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/30/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class FullTimeCollegeWorkingViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate {
 
    let cellIdentifier = "FullTimeCollegeCell"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var singleGirls = [SingleGirl]()
    var needsKoveaSingleGirls = [SingleGirl]()
    var doesNotNeedKoveaSingleSirls = [SingleGirl]()
   
    //var coreDataStack: CoreDataStack!
    var coreDataStack = CoreDataStack(modelName: "SingleGirl")
    var fetchRequest: NSFetchRequest<SingleGirl>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
        
        let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
                   
        request.sortDescriptors = [ageSortDescriptor]
        
      let dontNeedString = "Donotneedkoveahittim"
     let needString = "Needkoveahittim"
     let categoryString = "FullTimeCollege/Working"
        
      
        
        
        let categoryString0 = "FTC"
        let categoryString1 = "PTL+FTC"
        let categoryString2 = "FTL+PTL+FTC"
              
              
        let compoundPredicateNeedsKovea = NSPredicate(format:  "%K = %@ OR %K = %@ OR %K = %@",argumentArray:
            [#keyPath(SingleGirl.category),categoryString0,
            #keyPath(SingleGirl.category),categoryString1,
            #keyPath(SingleGirl.category),categoryString2
                  
        ])

        request.predicate =  compoundPredicateNeedsKovea
                   
        do {
         singleGirls =  try coreDataStack.mainContext.fetch(request)
               
         
          doesNotNeedKoveaSingleSirls =  singleGirls.filter { singleGirl in
                singleGirl.koveahIttim == "Donotneedkoveahittim"
            }
            
            needsKoveaSingleGirls =  singleGirls.filter {
                singleGirl in
                singleGirl.koveahIttim == "Needkoveahittim"
                       }
        
        tableView.reloadData()

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
           let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
           let normalTextAttributes = [NSAttributedString.Key.foregroundColor: segmentColor]
           segmentControl.selectedSegmentTintColor = segmentColor
           segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
           segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
           segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .highlighted)
        
        
        
      }
    
 
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        print("the selectedIndex is \(selectedIndex) and title is \(String(describing: sender.titleForSegment(at: selectedIndex)))")
        
        
        let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
        
        let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
                   
        request.sortDescriptors = [ageSortDescriptor]
        
        
        let categoryString0 = "FTC"
        let categoryString1 = "PTL+FTC"
        let categoryString2 = "FTL+PTL+FTC"
        
        
        
        let dontNeedString = "Donotneedkoveahittim"
           let needString = "Needkoveahittim"
           let categoryString = "FullTimeCollege/Working"
        
        
        let compoundPredicateNeedsKovea = NSPredicate(format: "%K = %@ AND %K = %@ OR %K = %@ OR %K = %@",argumentArray:
                [ #keyPath(SingleGirl.koveahIttim),needString,
                    #keyPath(SingleGirl.category),categoryString0,
                    #keyPath(SingleGirl.category),categoryString1,
                    #keyPath(SingleGirl.category),categoryString2
                    ])
        
        
              let compoundPredicateNoNeedKovea = NSPredicate(format: "%K = %@ OR %K = %@ OR %K = %@ AND %K = %@",argumentArray:
                               [#keyPath(SingleGirl.category),categoryString0,
                                #keyPath(SingleGirl.category),categoryString1,
                                #keyPath(SingleGirl.category),categoryString1,
                                #keyPath(SingleGirl.koveahIttim),dontNeedString
                     ])
        
        
        
        
                   
        if selectedIndex == 1 {
             request.predicate = compoundPredicateNeedsKovea
        } else {
        request.predicate = compoundPredicateNoNeedKovea
        }
                   
        do {
         singleGirls =  try coreDataStack.mainContext.fetch(request)
              
            print("the state of single girls is \(singleGirls.description)")
         
            tableView.reloadData()

        } catch let error as NSError {
                   print("Could not fetch \(error), \(error.userInfo)")
                   }
 
 
 }
    
    // MARK: - Table View Delegates
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        if segmentControl.selectedSegmentIndex == 0 {
            return doesNotNeedKoveaSingleSirls.count
        } else {
        return needsKoveaSingleGirls.count
       }
    }
  
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!
        FTCollegeTableViewCell
     
       
        
         let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        
         var currentGirl: SingleGirl!
        
        if segmentControl.selectedSegmentIndex == 0 {
        
        currentGirl = doesNotNeedKoveaSingleSirls[indexPath.row]
       } else {
         currentGirl = needsKoveaSingleGirls[indexPath.row]
        }
        
        let cellImage = UIImage(named: "\(currentGirl.imageName)")
        
        if cellImage != nil {
        cell.profileImageView?.image = cellImage
        } else {
            cell.profileImageView.image = UIImage(named: "face02")
        }
        
       cell.nameLabel.text = currentGirl.firstName + " " + currentGirl.lastName
                   
        // 2nd Label - age - height
         cell.ageHeightLabel.text = currentGirl.age + " - " + currentGirl.height!
                   
        // 3rd label - city
         cell.cityLabel.text = currentGirl.city
                   
        // 4th Label is category codes Label
        cell.categoryLabel.text = currentGirl.category 
                   
        // 5th Label -  seminary
         cell.seminaryLabel.text = currentGirl.seminary
        //cell.proPlanLabel.text = currentGirl.city
      
        // 6th Label - Pro Track
        
     
        // 6th Label Kovea Ittim
        if currentGirl.koveahIttim == "Donotneedkoveahittim" {
            
        cell.koveahIttimLabel.backgroundColor = UIColor.white
            
       
            
        cell.koveahIttimLabel.textColor = segmentColor
        cell.koveahIttimLabel.text = "Doesn't need kovea ittim"
        } else {
        
        cell.koveahIttimLabel.textColor = segmentColor
        cell.koveahIttimLabel.backgroundColor = UIColor.white
        cell.koveahIttimLabel.text = "Must be kovea ittimm"
        }
        
        return cell
    }
    
   
        
           
       
    
   
    
    // MARK:- Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ShowSingleDetails" {
        
        let controller = segue.destination as! SingleDetailViewController
        
        controller.managedObjectContext = coreDataStack.mainContext
        
        if let indexPath = tableView.indexPath(for: sender
               as! UITableViewCell) {
            
            var currentGirl: SingleGirl!
             
             if segmentControl.selectedSegmentIndex == 0 {
             
             currentGirl = doesNotNeedKoveaSingleSirls[indexPath.row]
            } else {
              currentGirl = needsKoveaSingleGirls[indexPath.row]
             }
    
        
        controller.selectedSingle = currentGirl
        }
     }
}
}
