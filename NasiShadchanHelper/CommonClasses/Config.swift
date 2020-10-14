//
//  Config.swift
//  NasiShadchanHelper
//
//  Created by user on 4/26/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation



func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

func calculateAgeFrom(dobString: String) -> Double {
    
    let dateString = dobString
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    
    dateFormatter.dateFormat = "MM-dd-yyyy"
    
    let date2 = dateFormatter.date(from: dateString)!
    
    let today = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year,.month, .day], from: date2, to: today)
    
    let ageYears = components.year
    print("the age  -\(ageYears!) - Years: -  \(components.month!) - months: and - \(components.day!) days")
    
    let decimal =  Double(components.month!) / Double(12)
    print("the decimal is \(decimal)")
    
    let compositeNumb = Double(ageYears!) + decimal
    
    var  roundedNumb =    Double(compositeNumb).rounded(toPlaces: 1)
    return roundedNumb
    
}

