//
//  AppDelegate.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
       
    let coreDataStack = CoreDataStack(modelName: "SingleGirl")
    
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //clearCoreData()
        
        if needJSONImport() == true {
          importJSONSeedData()
        }
        
        let tabController = window?.rootViewController as! UITabBarController
        
        let categoriesNavController = tabController.viewControllers?[0] as! UINavigationController
        
        let categoriesViewController = categoriesNavController.topViewController as! CategoriesViewController
        
        categoriesViewController.coreDataStack = coreDataStack
        
        
        let savedNavController = tabController.viewControllers?[1] as! UINavigationController
        let savedViewController = savedNavController.topViewController as! FavoritesViewController
        
        savedViewController.coreDataStack = coreDataStack
        
        FirebaseApp.configure()
        
        let age = calculateAgeFrom(dobString: "")
        
        
        return true
    }
    
    func clearCoreData() {
        let fetchRequest = NSFetchRequest<SingleGirl>(entityName: "SingleGirl")
        do {
        let results = try coreDataStack.mainContext.fetch(fetchRequest)
            results.forEach { coreDataStack.mainContext.delete($0)}
     
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("errror \(error)")
        }
    }
    
    func needJSONImport() -> Bool {
        
        let fetchRequest = NSFetchRequest<SingleGirl>(entityName: "SingleGirl")
        let count = try! coreDataStack.mainContext.count(for: fetchRequest)
        
        if count < 3 {
            return true
        } else {
            return false
        }
    }
    
    func importJSONSeedData() {
        let jsonURL = Bundle.main.url(forResource: "NasiHybridData", withExtension: "json")!
        
        let jsonData = try! Data(contentsOf: jsonURL)
        
        var jsonArray: [[String: AnyObject]] = []
        
        do {
            jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: AnyObject]]
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            abort()
        }
        
        var counter = 0
        for jsonDictionary in jsonArray {
            counter += 1
            
            // MARK: get each element from the array using indexes
            let  categoryWithSpace = jsonDictionary["Categories"] as! String
            
            let category = categoryWithSpace.replacingOccurrences(of: " ", with: "")
            
            
            
            let  ageNumb = jsonDictionary["Age"] as? Double
            
            var age = "NA"
            
            if ageNumb != nil {
            
            let  ageRounded =    Double(ageNumb!).rounded(toPlaces: 1)
            
             age = "\(ageRounded)"
            } else {
                age = "N/A"
            }
            
       
            let  lastName = jsonDictionary["Last Name:"] as! String
            let  firstName = jsonDictionary["First Name"] as! String
            
            let  city = jsonDictionary["City"] as! String
            
            let  seminaryOptional = jsonDictionary["Seminary"] as? String
            
            var seminary = "No Seminary"
           
            if seminaryOptional != nil {
                seminary = seminaryOptional!
            } else {
                seminary = "No Seminary"
            }
            
            var briefDescription = "N/A"
            let briefDescriptionJson = jsonDictionary["Self description"] as? String
            if briefDescriptionJson != nil {
                briefDescription = briefDescriptionJson!
            }
            
            
            let  lookingFor = jsonDictionary["Looking for"] as? String
            
            let  plan =  jsonDictionary["plan"] as! String
            
            let  yearsOfLearning = jsonDictionary["LTL/STL (sections)"] as! String
            
            
            let  koveahIttimSpaced  = jsonDictionary["Koveah Ittim"] as! String
            
            let koveahIttim = koveahIttimSpaced.replacingOccurrences(of: " ", with: "")
            
    let professionalTrackSpaced = jsonDictionary["Professional /Non Professional"] as! String
            
    let professionalTrack = professionalTrackSpaced.replacingOccurrences(of: " ", with: "")
            
            
          let contactLastNameJSon = jsonDictionary["Contact last name"] as? String
            
            var contactLastName = "N/A"
            if contactLastNameJSon != nil {
                contactLastName = contactLastNameJSon!
            } else {
                contactLastName = "Nil"
            }
            
            var contactFirstName = "N/A"
            let contactFirstNameJson = jsonDictionary["Contact first name"] as? String
            if contactFirstNameJson != nil {
                contactFirstName = contactFirstNameJson!
            }
             
            let contactName = contactFirstName + " " + contactLastName
            
             
            var contactEmail = "N/A"
            let contactEmailJSon = jsonDictionary["contact email"] as? String
            
            if contactEmailJSon != nil {
                contactEmail = contactEmailJSon!
            } else {
                contactEmail = "Nil"
            }
            
             let contactCellNumb = jsonDictionary["contact cell"] as? NSNumber
            
            var contactCell = "N/A"
            if contactCellNumb != nil {
                contactCell = "\(contactCellNumb!)"
            } else {
                contactCell = "Null"
            }
             
             let familySituation = jsonDictionary["Family Situation"] as! String
             
            let imageNameRaw = firstName + lastName
            let imageName = imageNameRaw.replacingOccurrences(of: " ", with: "")
            
            let heightInFt = jsonDictionary["Ft"]
            let heightInInches = jsonDictionary["inches"]
            
            let height = "\(heightInFt!)\'" + "\(heightInInches!)\""
            
            
            var isSaved: String
            if counter % 15 == 0 {
            
              isSaved = "true"
            } else {
                isSaved = "false"
            }
        /*
            print("*****counter is at: \(counter)\nthe value of names:\n \(firstName)\(lastName)\n Category:\(category)\n yearsOfLearning:\(yearsOfLearning)\nAGE:\(age)\n:Height:\(height)\n koveahIttim: \(koveahIttim): \nPlan: \(plan):\n NameOfImage: \(imageName):\n BriefDesc::\n:lookingFor: \(String(describing: lookingFor))\nthe values for kovaIttim are \(koveahIttim):\(koveahIttimSpaced)\nand PRO Track: \(professionalTrackSpaced)vs \(professionalTrack)")
            */
     
            
            
           
            let singleGirl = SingleGirl(context: coreDataStack.mainContext)
            singleGirl.firstName = firstName
            singleGirl.lastName = lastName
            singleGirl.category = category
            singleGirl.city = city
            singleGirl.plan = plan
            singleGirl.age = age
            singleGirl.yearsOfLearning = yearsOfLearning
            singleGirl.koveahIttim = koveahIttim
            singleGirl.professionalTrack = professionalTrack
            singleGirl.height = height
            singleGirl.briefDescription = briefDescription
            singleGirl.lookingFor = lookingFor
            singleGirl.imageName = imageName
            singleGirl.isSaved = "false"
            singleGirl.seminary = seminary
            singleGirl.contactName = contactName
            singleGirl.contactEmail = contactEmail
            singleGirl.contactCell = contactCell
            singleGirl.familySituation = familySituation
            coreDataStack.saveContext()
        }
 
        }
          
    }
    



    
    
    

   
    
    
   
    
    
      
        
            
        
                
               
                
              
                
                
               
                
          
                
                       
                
           
             
    

           
          
    

