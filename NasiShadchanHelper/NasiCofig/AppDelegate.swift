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
        Firebase.Analytics.setAnalyticsCollectionEnabled(true)

        // -- IQKeyboardManager---
        IQKeyboardManager.shared.enable = true
        
        if UserInfo.currentUserExists {
             self.makingRootFlow(Constant.AppRootFlow.kEnterApp)
        } else {
             self.makingRootFlow(Constant.AppRootFlow.kAuthVc)
        }
       // setUpNavigationAppearance()
        return true
    }
    
    // MARK:- MEthods
    private func setUpNavigationAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1979975104, green: 0.628539741, blue: 0.6259952784, alpha: 1)
        UINavigationBar.appearance().backgroundColor = .black
        UIBarButtonItem.appearance() .tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
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






































