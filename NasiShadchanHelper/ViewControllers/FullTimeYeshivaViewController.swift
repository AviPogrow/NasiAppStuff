//
//  FullTimeYeshivaViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData 

class FullTimeYeshivaViewController: UITableViewController, NSFetchedResultsControllerDelegate {


    // MARK: - Properties
    fileprivate let singleCellIdentifier = "SingleCellID"
    

    var coreDataStack = CoreDataStack(modelName: "SingleGirl")
    var singleGirls = [SingleGirl]()
    
    var onetothreeSingleGirls = [SingleGirl]()
    var threeToFiveSingleGirls = [SingleGirl]()
    var fiveYearsSingleGirls = [SingleGirl]()
    var fiveToSevenSingleGirls = [SingleGirl]()
    var sevenPlusSingleGirls = [SingleGirl]()
    
   let fullTimeYeshivaPredicate = NSPredicate(format: "%K == %@", #keyPath(SingleGirl.category), "FullTimeYeshiva")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.title = "Full Time Yeshiva"
        
        let fetchRequest: NSFetchRequest<SingleGirl>  = SingleGirl.fetchRequest()
          
        let ageSort = NSSortDescriptor(key: #keyPath(SingleGirl.age), ascending: true)
            
            
          fetchRequest.sortDescriptors = [ageSort]
            
            let predicateString1 = "FTL"
            let predicateString2 = "FTL+PTL+FTC"
            let predicateString3 = "FTL+PTL"

            
            let hybridPredicate =
            NSPredicate(format: "%K = %@ OR %K = %@ OR %K = %@",
                    argumentArray:
             [#keyPath(SingleGirl.category), predicateString1,
             #keyPath(SingleGirl.category),predicateString2,
             #keyPath(SingleGirl.category),predicateString3,
            ])
            
          fetchRequest.predicate = hybridPredicate
          
          
          singleGirls =  try! coreDataStack.mainContext.fetch(fetchRequest)
        
        onetothreeSingleGirls = singleGirls.filter { singleGirl in
            singleGirl.yearsOfLearning == "1-3" || singleGirl.yearsOfLearning == "1-3:3-5" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5"
        }
        
        threeToFiveSingleGirls = singleGirls.filter { singleGirl in
            singleGirl.yearsOfLearning == "3-5" ||
            singleGirl.yearsOfLearning == "1-3:3-5" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5" ||
            singleGirl.yearsOfLearning == "3-5:5" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7"
        }
        
        fiveYearsSingleGirls = singleGirls.filter { singleGirl in
            singleGirl.yearsOfLearning == "5" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5" ||
            singleGirl.yearsOfLearning == "3-5:5" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7" ||
            singleGirl.yearsOfLearning == "5:5-7:7+"
            
        }
        
        fiveToSevenSingleGirls = singleGirls.filter { singleGirl in
            singleGirl.yearsOfLearning == "5-7" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7" ||
            singleGirl.yearsOfLearning == "5:5-7" ||
            singleGirl.yearsOfLearning == "5-7:7+"
        }
        sevenPlusSingleGirls = singleGirls.filter { singleGirl in
            singleGirl.yearsOfLearning == "7+" ||
            singleGirl.yearsOfLearning == "5:5-7:7+" ||
            singleGirl.yearsOfLearning == "5-7:7+"
            
        }
      
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
         
      return 5
     }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "1 - 3 Years of Learning"
        } else if section == 1 {
            return "3 - 5 Years of Learning"
        } else if section == 2 {
            return "5  Years of Learning"
        } else if section == 3 {
            return "5 - 7 Years of Learning"
        } else {
            return "7+ Years Of Learning"
        }
    }

   // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if section == 0 {
            return onetothreeSingleGirls.count
        } else if section == 1 {
            return threeToFiveSingleGirls.count
        } else if section == 2 {
            return fiveYearsSingleGirls.count
        } else if section == 3  {
            return fiveToSevenSingleGirls.count
            
        } else {
            return sevenPlusSingleGirls.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: singleCellIdentifier, for: indexPath) as! SingleTableViewCell

        
        var currentSingle: SingleGirl!
        if indexPath.section == 0 {
            currentSingle = onetothreeSingleGirls[indexPath.row]
        } else if indexPath.section == 1 {
         currentSingle = threeToFiveSingleGirls[indexPath.row]
        } else if indexPath.section == 2 {
            currentSingle = fiveYearsSingleGirls[indexPath.row]
        } else if indexPath.section == 3 {
            currentSingle = fiveToSevenSingleGirls[indexPath.row]
        } else {
            currentSingle = sevenPlusSingleGirls[indexPath.row]
        }
        
        //top 1 name
        cell.nameLabel?.text =  "\(currentSingle.firstName)" + " "  + "\(currentSingle.lastName)"
        
        // 2nd Age - Height
        cell.ageHeightLabel.text = currentSingle.age + "-" + currentSingle.height!
        
        // 3rd Label - City
       
        cell.cityLabel.text = "\(currentSingle.city)"
        
        // 4th Label - Categories
        cell.categoryLabel.textColor = .lightGray
        cell.categoryLabel.text = "\(currentSingle.category) - " + currentSingle.yearsOfLearning
        
        //5th Label - Seminary
       cell.SeminaryLabel.text = currentSingle.seminary
        
        // 6th Label - Plan
        cell.parnassahPlanLabel.text = "\(currentSingle.plan)"
                                  
        
        
        
        let nameOfImage = "\(currentSingle.imageName)"
        
        let fixedImageName = nameOfImage.replacingOccurrences(of: " ", with: "")
        let currentSingleImage = UIImage(named: fixedImageName)
        
         if currentSingleImage != nil {
           cell.profileImageView.image = currentSingleImage
        } else {
            cell.profileImageView.image = UIImage(named: "ReenaAbady")
            
        }
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 44
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       if segue.identifier == "ShowSingleDetail" {
        guard let tableViewCell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: tableViewCell),
          let controller = segue.destination as? SingleDetailViewController else {
            return
        }
        
        controller.managedObjectContext = coreDataStack.mainContext
        
        var currentSingle: SingleGirl!
               if indexPath.section == 0 {
                   currentSingle = onetothreeSingleGirls[indexPath.row]
               } else if indexPath.section == 1 {
                currentSingle = threeToFiveSingleGirls[indexPath.row]
               } else if indexPath.section == 2 {
                   currentSingle = fiveYearsSingleGirls[indexPath.row]
               } else if indexPath.section == 3 {
                   currentSingle = fiveToSevenSingleGirls[indexPath.row]
               } else {
                currentSingle = sevenPlusSingleGirls[indexPath.row]
        }

        controller.selectedSingle = currentSingle
        }
    }
}



