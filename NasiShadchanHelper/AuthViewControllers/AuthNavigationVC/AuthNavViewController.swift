//
//  AuthNavViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//


import UIKit

//MARK: NasiAuthDelegate
protocol NasiAuthDelegate {
    func userDidCompleteSignIn()
    func userDidCompleteSignUp()
    func userDidCancelSignUpSignIn()
}

//MARK: AuthNavViewController
class AuthNavViewController: UINavigationController {
    
    var authDelegate : NasiAuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func dismissView() {
       self.dismiss(animated: true, completion: nil)
    }
    
    func userCancelSignInSingUp() {
        self.dismissView()
        authDelegate?.userDidCancelSignUpSignIn()
    }

}
