//
//  DataModel.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation
import CoreData

class DataModel {
    
    var singleGirlsArray =  [SingleGirl]()
    
    func loadDataFromFile() {
        
      // get the path to the file in main bundle
                 let path = Bundle.main.path(forResource: "Nasi", ofType: "txt")
                  
                  // load it into a string object
                  let singlesString = try? String(contentsOfFile: path!)
                  
                  let allSingles = singlesString!.components(separatedBy: "\n")
                  
               // drop the first until data cleaned
            let allSinglesArray = allSingles.dropFirst
        
        var counter = 1
        for  single in allSingles {
           
            if counter == allSingles.count {
                break
            }
             
           
             
              
              let firstSingleSplit = single.components(separatedBy: "\t")
              
              let firstSingleIndex = firstSingleSplit.startIndex
              
              let indexOfLastName = firstSingleIndex.advanced(by: 2)
              let indexOfFirstName = firstSingleIndex.advanced(by: 3)
              let indexOfAge = firstSingleIndex.advanced(by: 5)
              let indexOfCity = firstSingleIndex.advanced(by: 6)
              let indexOFHeightINFT = firstSingleIndex.advanced(by: 9)
              let indexOFHeightININCHES = firstSingleIndex.advanced(by: 10)
              let indexForBoyCategory = firstSingleIndex.advanced(by: 11)
              
              let lastName = firstSingleSplit[indexOfLastName]
              let firstName = firstSingleSplit[indexOfFirstName]
              let age = firstSingleSplit[indexOfAge]
              let city = firstSingleSplit[indexOfCity]
              let heightFT = firstSingleSplit[indexOFHeightINFT]
              let heightInches = firstSingleSplit[indexOFHeightININCHES]
              
              let totalHeight = "\(heightFT)ft" + " " + "\(heightInches)inches"
              
              
              
            let boyCategory = firstSingleSplit[indexForBoyCategory]
              
            print("the unrefined boy category string is \(boyCategory)")
            
            let refinedBoyCategory = refineCategoryString(categoryString: boyCategory)
              
            
            
            let singleGirl = SingleGirl(lastName: lastName, firstName: firstName, city: city, height: totalHeight, age: age, boyCategory: refinedBoyCategory)
            
            
            singleGirlsArray.append(singleGirl)
            //print("the singleGirlsArray is \(singleGirlsArray.description)*** \(singleGirlsArray.first)***")
              
            // increment the counter
            counter = counter + 1
        }
    }
    // Curently learning full time in Yeshiva, Currently part time in Yeshiva and college/working, Currently full time in college or full time working
    // Curently learning full time in Yeshiva, Currently part time in Yeshiva and college/working
    //Currently part time in Yeshiva and college/working, Currently full time in college or full time working
    //Curently learning full time in Yeshiva
    //Currently full time in college or full time working
    
    var refined1 = "Any Cateogry of Boy"
    var refined2 = "Only Full Time in Yeshiva"
    var refined3 = "Only Full Time Working (or College)"
    var refined4 = "Either Part Time College(Work)  or Full Time College(Work)"
    var refined5 = "Either Learning Full Time or At Least Part Time"
    
    func refineCategoryString(categoryString: String) -> String {
        var refinedString = ""
        if categoryString == "Curently learning full time in Yeshiva, Currently part time in Yeshiva and college/working, Currently full time in college or full time working" {
            refinedString = refined1
        } else if categoryString == "Curently learning full time in Yeshiva" {
            refinedString = refined2
        } else if categoryString == "Currently full time in college or full time working" {
            refinedString = refined3
        } else if categoryString == "Currently part time in Yeshiva and college/working, Currently full time in college or full time working" {
            refinedString = refined4
        } else if categoryString == "Curently learning full time in Yeshiva, Currently part time in Yeshiva and college/working" {
            refinedString = refined5
        }
        
        return refinedString
    }
}
