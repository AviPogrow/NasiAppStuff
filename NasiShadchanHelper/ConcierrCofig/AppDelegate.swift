//
//  AppDelegate.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    class func instance() -> AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        // -- IQKeyboardManager---
        IQKeyboardManager.shared.enable = true
        
        if UserInfo.currentUserExists {
             self.makingRootFlow(Constant.AppRootFlow.kEnterApp)
        } else {
             self.makingRootFlow(Constant.AppRootFlow.kAuthVc)
        }
        
        return true
    }
    
    // MARK: - Making RootView Controller
    func makingRootFlow(_ strRoot: String) {
        self.window?.rootViewController?.removeFromParent()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if strRoot == Constant.AppRootFlow.kEnterApp {
            let tabBar = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
            window?.rootViewController = tabBar
        } else if strRoot == Constant.AppRootFlow.kAuthVc {
            let authStoryboard = UIStoryboard(name: "UserAuthentication", bundle: nil)
            let vcNav : AuthNavViewController = authStoryboard.instantiateViewController()
            window?.rootViewController = vcNav
        }
    }
    
    func serviceDetailRootController() {
        let vcUserAuth = UIStoryboard.init(name: "UserAuthentication", bundle: nil).instantiateInitialViewController()
        UIView.transition(with:window!, duration:0.5, options:.transitionCrossDissolve, animations: {
            self.window?.rootViewController = vcUserAuth
        }) { (completed) in}
    }
        
}






































