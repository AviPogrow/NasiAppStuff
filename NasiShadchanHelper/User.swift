//
//  User.swift
//  NasiShadchanHelper
//
//  Created by user on 5/29/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation


struct ShadchanSingle {
   var  lastName: String!
   var firstName: String!
    var notes: String!
    var redIdeas: String!
    
}

struct User {
    var name: String
    var email: String
    var shadchanSingles: [ShadchanSingle]
}
