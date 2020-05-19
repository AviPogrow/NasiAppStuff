//
//  AppDelegate.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

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
            
            print("value of age is:" + age)
            
            
            
            
           
            
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
            print("yearsOfLearning is \(yearsOfLearning)")
            
            
           
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
    
    
    
   
    
    /*
      func insertSeedData() {
           
        let path = Bundle.main.path(forResource: "Nasi(4)", ofType: "tsv")
                
        var  rawSinglesString = try! String(contentsOfFile: path!)
               
        // each line or row is one single
        var rowsOfSingles = rawSinglesString.components(separatedBy: "\n")
                

        rowsOfSingles.dropFirst()
       
        var counter = 0
        // iterate over the rows of singles
        // where each row has an array of columns
        for (index, row) in rowsOfSingles.enumerated() {
        
            
        counter = counter + 1
         let columns = row.components(separatedBy: "\t")
     
        // MARK: - Get the indexes for all the elements we will
                // want to extract
                // get the indexes to the elements in the array
                // we need to pull out
                let timeStampIndex = columns.startIndex + 1
                
                let emailIndex = timeStampIndex.advanced(by: 1)
                let lastNameIndex = timeStampIndex.advanced(by: 2)
                let firstNameIndex = timeStampIndex.advanced(by: 3)
                
               
                
                
                let telephoneIndex = timeStampIndex.advanced(by: 4)
                let dobIndex = timeStampIndex.advanced(by: 5)
                let cityIndex = timeStampIndex.advanced(by: 6)
                let stateIndex = timeStampIndex.advanced(by: 7)
                let zipIndex = timeStampIndex.advanced(by: 8)
                let heightFTIndex = timeStampIndex.advanced(by: 9)
                let heightINCHIndex = timeStampIndex.advanced(by: 10)
                
                //"learning does not need a plan"
                let learningPlanIndex = timeStampIndex.advanced(by: 12)
                let yearsOfLearningIndex = timeStampIndex.advanced(by: 13)
                let koveahIttimIndex = timeStampIndex.advanced(by: 15)
                let seminaryIndex = timeStampIndex.advanced(by: 16)
                let lookingForIndex = timeStampIndex.advanced(by: 18)
                let briefDescriptionIndex = timeStampIndex.advanced(by: 19)
                
                // "does not need professional track"
                let professionalTrackIndex = timeStampIndex.advanced(by: 27)
                let boyCategoryIndex = timeStampIndex.advanced(by: 32)
                let ageIndex = timeStampIndex.advanced(by: 33)
                
                
               
                
               // MARK: get each element from the array using indexes
               let  category = columns[boyCategoryIndex]
               let  age = columns.last!
               let  lastName = columns[lastNameIndex]
               let  firstName = columns[firstNameIndex]
               let  city = columns[cityIndex]
                
                       
                
                
               let  briefDescription = columns[briefDescriptionIndex]
               let  lookingFor = columns[lookingForIndex]
               let  plan =  columns[learningPlanIndex]
               let  yearsOfLearning = columns[yearsOfLearningIndex]
               let  koveahIttim  = columns[koveahIttimIndex]
               let  professionalTrack = columns[professionalTrackIndex]
               
                // combine the height and inches and insert height and
                // feet indicators ex: 5"3'
                let  combinedHeight = columns[heightFTIndex] + "\"" +        columns[heightINCHIndex] + "\'"
                let  height  = combinedHeight
                
                // compute the image name by combining first/last name
                // and removing spaces
                let imageNameRaw = columns[firstNameIndex] + columns[lastNameIndex]
                let imageName = imageNameRaw.replacingOccurrences(of: " ", with: "")
           
               var  isSaved = "false"
    
         print("category: \(category)firstName: \(firstName)LastName: \(lastName)city: \(city) height: \(height) imageName: \(imageName) ProTrack: \(professionalTrack) KoveahIttim: \(koveahIttim) YearsLearning:\(yearsOfLearning) isSaved: \(isSaved) Plan: \(plan) age: \(age)****stateOfColumnsArray\(columns)")

           
           //MARK: Core Data Init
        
          let singleGirl = SingleGirl(context: coreDataStack.mainContext)
           
           // set the properties
           singleGirl.firstName = firstName
           singleGirl.lastName = lastName
          singleGirl.age = age
           singleGirl.category = category
           singleGirl.height = height
           singleGirl.lookingFor = lookingFor
           singleGirl.briefDescription = briefDescription
           singleGirl.isSaved = isSaved
           singleGirl.imageName = imageName
           singleGirl.professionalTrack = professionalTrack
           singleGirl.yearsOfLearning = yearsOfLearning
           singleGirl.plan = plan
           singleGirl.koveahIttim = koveahIttim
            singleGirl.city = city
            
            if counter == 21 {
                coreDataStack.saveContext()
                coreDataStack.mainContext.reset()
            }
            
        }
        
    coreDataStack.saveContext()
    coreDataStack.mainContext.reset()
    print("Imported \(counter) singleGirls.")
            }
 */
  //  }
        
    

