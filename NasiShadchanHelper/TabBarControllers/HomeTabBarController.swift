//
//  HomeTabBarController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

let corner : CGFloat = 5.0

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:Sign In
    func askForUserSignIn(_ withDelegation : Bool) {
        let stryBoardAuth : UIStoryboard = UIStoryboard.init(name: "UserAuthentication", bundle: nil)
        let vcNav : AuthNavViewController = stryBoardAuth.instantiateViewController(withIdentifier: "AuthNavViewController") as! AuthNavViewController
        self.present(vcNav, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
    }
}


