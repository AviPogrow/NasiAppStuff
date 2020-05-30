//
//  SingleGirl+CoreDataClass.swift
//  NasiShadchanHelper
//
//  Created by user on 4/26/20.
//  Copyright © 2020 user. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(SingleGirl)
public class SingleGirl: NSManagedObject {
    

    var hasPhoto: Bool {
      return photoID != nil
    }
    
    
    // construct a computed url property
    // pass in the calculated number
    // use it to construct a file name and append
    // it to document directory
    var photoURL: URL {
      assert(photoID != nil, "No photo ID set")
      let filename = "Photo-\(photoID!.intValue).jpg"
      return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    
    // pass in the file path to the UIImage init
    var photoImage: UIImage? {
      return UIImage(contentsOfFile: photoURL.path)
    }
    
    // create new Int value for photoID
    // and store it in userDefaults
    class func nextPhotoID() -> Int {
       let userDefaults = UserDefaults.standard
       let currentID = userDefaults.integer(forKey: "PhotoID") + 1
       userDefaults.set(currentID, forKey: "PhotoID")
       userDefaults.synchronize()
       return currentID
     }
    func removePhotoFile() {
      if hasPhoto {
        do {
          try FileManager.default.removeItem(at: photoURL)
        } catch {
          print("Error removing file: \(error)")
        }
      }
    }
    

}
