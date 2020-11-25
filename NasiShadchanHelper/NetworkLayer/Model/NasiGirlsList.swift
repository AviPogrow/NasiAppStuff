//
//  File.swift
//  NasiShadchanHelper
//
//  Created by apple on 01/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation
import ObjectMapper

class NasiGirlsList : Mappable {
    var briefDescriptionOfWhatGirlIsLike : String?
    var briefDescriptionOfWhatGirlIsLookingFor : String?
    var category : String?
    var cellNumberOfContactToReddShidduch : String?
    var cityOfResidence : String?
    var currentGirlUID : String?
    var dateOfBirth : Double?
    var documentDownloadURLString : String?
    var emailOfContactToReddShidduch : String?
    var emailOfContactWhoKnowsGirl : String?
    var firstNameOfGirl : String?
    var firstNameOfPersonToContactToReddShidduch : String?
    var fullhebrewNameOfGirlAndMothersHebrewName : String?
    var girlsCellNumber : String?
    var girlsEmailAddress : String?
    var heightInFeet : String?
    var heightInInches : String?
    var imageDownloadURLString : String?
    var lastNameOfGirl : String?
    var lastNameOfPersonToContactToReddShidduch : String?
    var middleNameOfGirl : String?
    var nameSheIsCalledOrKnownBy : String?
    var plan : String?
    var relationshipOfThisContactToGirl : String?
    var seminaryName : String?
    var stateOfResidence : String?
    var yearsOfLearning : String?
    var zipCode : String?
    var cellNumberOfContactWhoKNowsGirl : String?
    var firstNameOfAContactWhoKnowsGirl : String?
    var girlFamilyBackground : String?
    var koveahIttim :String?
    var lastNameOfAContactWhoKnowsGirl :String?
    var livingInIsrael :String?
    var professionalTrack :String?
    var girlFamilySituation :String?
        
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        briefDescriptionOfWhatGirlIsLike <- map["briefDescriptionOfWhatGirlIsLike"]
        briefDescriptionOfWhatGirlIsLookingFor <- map["briefDescriptionOfWhatGirlIsLookingFor"]
        category <- map["category"]
        cellNumberOfContactToReddShidduch <- map["cellNumberOfContactToReddShidduch"]
        cellNumberOfContactWhoKNowsGirl <- map["cellNumberOfContactWhoKNowsGirl"]
        cityOfResidence <- map["cityOfResidence"]
        currentGirlUID <- map["currentGirlUID"]
        dateOfBirth <- map["dateOfBirth"]
        documentDownloadURLString <- map["documentDownloadURLString"]
        emailOfContactToReddShidduch <- map["emailOfContactToReddShidduch"]
        emailOfContactWhoKnowsGirl <- map["emailOfContactWhoKnowsGirl"]
        firstNameOfGirl <- map["firstNameOfGirl"]
        firstNameOfPersonToContactToReddShidduch <- map["firstNameOfPersonToContactToReddShidduch"]
        fullhebrewNameOfGirlAndMothersHebrewName <- map["fullhebrewNameOfGirlAndMothersHebrewName"]
        girlsCellNumber <- map["girlsCellNumber"]
        girlsEmailAddress <- map["girlsEmailAddress"]
        heightInFeet <- map["heightInFeet"]
        heightInInches <- map["heightInInches"]
        imageDownloadURLString <- map["imageDownloadURLString"]
        lastNameOfGirl <- map["lastNameOfGirl"]
        lastNameOfPersonToContactToReddShidduch <- map["lastNameOfPersonToContactToReddShidduch"]
        middleNameOfGirl <- map["middleNameOfGirl"]
        nameSheIsCalledOrKnownBy <- map["nameSheIsCalledOrKnownBy"]
        plan <- map["plan"]
        relationshipOfThisContactToGirl <- map["relationshipOfThisContactToGirl"]
        seminaryName <- map["seminaryName"]
        stateOfResidence <- map["stateOfResidence"]
        yearsOfLearning <- map["yearsOfLearning"]
        zipCode <- map["zipCode"]
        firstNameOfAContactWhoKnowsGirl <- map["firstNameOfAContactWhoKnowsGirl"]
        girlFamilyBackground <- map["girlFamilyBackground"]
        koveahIttim <- map["koveahIttim"]
        lastNameOfAContactWhoKnowsGirl <- map["lastNameOfAContactWhoKnowsGirl"]
        livingInIsrael <- map["livingInIsrael"]
        professionalTrack <- map["professionalTrack"]
        girlFamilySituation <- map["girlFamilySituation"]
    }
}

