//
//  SingleGirl+CoreDataProperties.swift
//  NasiShadchanHelper
//
//  Created by user on 4/26/20.
//  Copyright © 2020 user. All rights reserved.
//
//

import Foundation
import CoreData


extension SingleGirl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleGirl> {
        return NSFetchRequest<SingleGirl>(entityName: "SingleGirl")
    }

    @NSManaged public var category: String
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var age: String
    @NSManaged public var lastName: String
    @NSManaged public var firstName: String
    @NSManaged public var imageName: String
    @NSManaged public var city: String
    @NSManaged public var height: String?
    @NSManaged public var briefDescription: String?
    @NSManaged public var lookingFor: String?
    @NSManaged public var plan: String
    @NSManaged public var yearsOfLearning: String
    @NSManaged public var koveahIttim: String
    @NSManaged public var professionalTrack:String
    @NSManaged public var isSaved:String
    @NSManaged public var seminary:String
    @NSManaged public var contactName:String
    @NSManaged public var contactEmail:String
    @NSManaged public var contactCell:String
    @NSManaged public var familySituation:String
    
    
     @NSManaged public var photoID: NSNumber?
   
}
