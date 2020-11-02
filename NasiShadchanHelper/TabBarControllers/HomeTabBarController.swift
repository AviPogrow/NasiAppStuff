//
//  HomeTabBarController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

let corner : CGFloat = 5.0

class HomeTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.delegate = self
        self.tabBar.backgroundColor  = .white
    }
    
    //MARK:Sign In
    func askForUserSignIn(_ withDelegation : Bool) {
        let stryBoardAuth : UIStoryboard = UIStoryboard.init(name: "UserAuthentication", bundle: nil)
        let vcNav : AuthNavViewController = stryBoardAuth.instantiateViewController(withIdentifier: "AuthNavViewController") as! AuthNavViewController
        self.present(vcNav, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
    }
    
    //MARK:- UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         // TODO: Setup parent controller in tabbar with remove all chailed controller
        if (viewController is UINavigationController) {
            let navcontrollers = viewController as? UINavigationController
            navcontrollers?.popToRootViewController(animated: false)
        }
    }

}


