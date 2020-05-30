//
//  YeshivaAndCollegeWorkingViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/1/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class YeshivaAndCollegeWorkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var singleGirls =  [SingleGirl]()
    var proTracKSingleGirls = [SingleGirl]()
    var noProTrackSingleGirls = [SingleGirl]()
    
    
    
    var coreDataStack = CoreDataStack(modelName: "SingleGirl")
    // var coreDataStack: CoreDataStack!
    let cellID = "HTCollegeTableCell"
    
    var selectedCategory = "YeshivaandCollege/Working"
    
    
    let categoryString0 = "FTL+PTL+FTC"
     let categoryString1 = "FTL+PTL"
    let categoryString2 = "PTL+FTC"
    let categoryString3 = "PTL"
   
    let str1 = "Doesnotneedprofessionaltrack"
   let str2 = "N/A"
   let str3 = "Needsprofessionaltrack"
     
   override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
   let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
    let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
    request.sortDescriptors = [ageSortDescriptor]
        
       
        
         
    let compoundPredicate1 = NSPredicate(format: "%K = %@ OR %K = %@ OR %K = %@",argumentArray:
            [#keyPath(SingleGirl.category),categoryString0,
             #keyPath(SingleGirl.category),categoryString1,
             #keyPath(SingleGirl.category),categoryString2])
        
            
        request.predicate = compoundPredicate1
            
        do {
        singleGirls =  try coreDataStack.mainContext.fetch(request)
        
        noProTrackSingleGirls = singleGirls.filter { singleGirl in
            singleGirl.professionalTrack == "Doesnotneedprofessionaltrack"
        }
      proTracKSingleGirls = singleGirls.filter{ singleGirl in
        singleGirl.professionalTrack == "Needsprofessionaltrack"
                
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
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        tableView.reloadData()

      }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    if segmentControl.selectedSegmentIndex == 0 {
        return proTracKSingleGirls.count
    }
        return noProTrackSingleGirls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as!  HTCollegeTableViewCell
        
        var currentSingle: SingleGirl!
        if segmentControl.selectedSegmentIndex == 0 {
            currentSingle = proTracKSingleGirls[indexPath.row]
        } else {
           currentSingle = noProTrackSingleGirls[indexPath.row]
        }
        
        let nameOfImage = "\(currentSingle.imageName)"
        
        let fixedImageName = nameOfImage.replacingOccurrences(of: " ", with: "")
        
        let imageForProfile = UIImage(named: fixedImageName)
        if imageForProfile != nil {
            cell.profileImageView.image = imageForProfile
        } else {
            cell.profileImageView.image = UIImage(named:"face02")
        }
        
        
        // 1st Label - Age
        cell.nameLabel.text = currentSingle.firstName + " " + currentSingle.lastName
        
        // 2nd Label - Age/Height
        cell.ageHeightLabel.text = currentSingle.age + " - " + currentSingle.height!
         
        
        // 3rd Label
        cell.cityLabel.textColor = UIColor.black
        cell.cityLabel.text =  currentSingle.city
        
        // 4th Label
        cell.categoryLabel.textColor = .lightGray
        cell.categoryLabel.text = currentSingle.category 
     
      // 5th Label is seminary
        cell.seminaryLabel.text = currentSingle.seminary
        
        
      // 6th label - Pro Track
         let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        
        if currentSingle.professionalTrack == "Doesnotneedprofessionaltrack" {
            
       cell.professionalTrackLabel.textColor = segmentColor
         cell.professionalTrackLabel.text = "Doesn't Need Pro Track"
        } else {
        cell.professionalTrackLabel.textColor = segmentColor
        cell.professionalTrackLabel.text = "Needs Pro Track"
        }
        return cell
    }
    
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowDetails" {
       let controller = segue.destination as! SingleDetailViewController
        controller.managedObjectContext = coreDataStack.mainContext
        
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            
            var currentSingle: SingleGirl!
            if segmentControl.selectedSegmentIndex == 0 {
                currentSingle = proTracKSingleGirls[indexPath.row]
            } else {
               currentSingle = noProTrackSingleGirls[indexPath.row]
            }
            
      
        controller.selectedSingle = currentSingle
        }
        }
    }
    
}
