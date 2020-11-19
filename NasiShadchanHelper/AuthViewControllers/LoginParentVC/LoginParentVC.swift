
//
//  LoginParentVC.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

import FirebaseAuth
import GoogleSignIn

class LoginParentVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - OVERRIDE METHOD(S)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Scroll Methods
    func displayPage(_ pageNum : Int, animate : Bool) {
        scrollView.isScrollEnabled = true
        scrollView.scrollRectToVisible(CGRect.init(x: scrollView.frame.size.width * CGFloat(pageNum), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height), animated: animate)
        scrollView.isScrollEnabled = false
    }
    
    //Google Sign In Methods
    func signInWithGoogle() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: IBActions
    @IBAction func btnCancelTapped(_ sender: Any) {
        /*
         if let vcNav : AuthNavViewController = self.navigationController as? AuthNavViewController { vcNav.userCancelSignInSingUp() }
         self.navigationController?.dismiss(animated: true, completion: nil)
         */
    }
}

extension LoginParentVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            self.firebaseLogin(credential)
        }
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        self.view.showLoadingIndicator()
        if let user = Auth.auth().currentUser {
            user.link(with: credential) { (authResult, error) in
                if error != nil {
                    self.view.hideLoadingIndicator()
                    self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: error!.localizedDescription, onDismiss: { })
                } else {
                    //self.validateUserEmailWithConcierr(Auth.auth().currentUser?.email ?? "")
                }
            }
        } else {
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    self.view.hideLoadingIndicator()
                    self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: error!.localizedDescription, onDismiss: { })
                } else {
                   // self.validateUserEmailWithConcierr(Auth.auth().currentUser?.email ?? "")
                }
            }
        }
    }
}
