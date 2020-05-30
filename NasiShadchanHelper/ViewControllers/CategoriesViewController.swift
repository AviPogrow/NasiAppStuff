//
//  CategoriesViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CategoriesViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    var allSingles: [SingleGirl]!
    
    //let ref = Database.database().reference(withPath: "grocery-items")

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    if segue.identifier == "ShowFullTimeYeshiva" {
         
        let controller = segue.destination as! FullTimeYeshivaViewController
        
        //controller.coreDataStack = coreDataStack
            
      } else if segue.identifier == "ShowFullTimeCollege/Working" {
         let controller = segue.destination as! FullTimeCollegeWorkingViewController
     
        //controller.coreDataStack = coreDataStack
            
        } else if segue.identifier  == "ShowYeshivaAndCollege/Working" {
        
       let controller = segue.destination as! YeshivaAndCollegeWorkingViewController
       
        // controller.coreDataStack = coreDataStack
        
        }
    }
    
   
    
 }

