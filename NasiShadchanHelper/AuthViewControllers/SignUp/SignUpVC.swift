//
//  SignUpVC.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import ObjectMapper

class SignUpVC: UIViewController {
    
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var tfEmail: AlignedPlaceholderTextField!
    @IBOutlet weak var tfPassword: AlignedPlaceholderTextField!
    @IBOutlet weak var tfRePassword: AlignedPlaceholderTextField!
    @IBOutlet weak var heightTopImage: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: UI Setup
    func setupUI() {
        self.viewForm.roundViewTopEdges(radius: 15)
        self.tfEmail.addLeftPadding()
        self.tfPassword.addLeftPadding()
        self.tfRePassword.addLeftPadding()
        self.tfRePassword.txtConfirmtext = self.tfPassword
        
        if AppDelegate.instance().window?.frame.size.height ?? 0.0 < 600.0 {
            self.heightTopImage.constant = 220
        } else {
            self.heightTopImage.constant = (AppDelegate.instance().window?.frame.size.height)! - (Utility.hasTopNotch ? 550 : 410)
        }
        
        for view: UIView in self.viewForm.subviews {
            if (view is UITextField) {
                let txtFld: UITextField? = (view as? UITextField)
                txtFld?.addRoundedViewCorners(width: 8, colorBorder: .lightGray)
            }
            if (view is UIButton) {
                let btn: UIButton? = (view as? UIButton)
                if btn?.tag == 100 {
                    btn?.setCornerRadius(radius: 8, colorBorder: .clear)
                } else if btn?.tag == 200 {
                    btn?.setCornerRadius(radius: 8, colorBorder: .lightGray)
                }
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    //MARK: Validaitons
    func validateFormFields() -> Bool {
        self.tfEmail.validate(); self.tfPassword.validate(); self.tfRePassword.validate()
        if self.tfEmail.validate() && self.tfPassword.validate() && self.tfRePassword.validate() {
            return true
        }
        return false
    }
    
    //MARK: IBActions
    @IBAction func btnSignUpTapped(_ sender: Any) {
        if validateFormFields() {
            self.view.showLoadingIndicator()
            Auth.auth().createUser(withEmail: tfEmail.text ?? "", password: tfPassword.text ?? "") { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                strongSelf.view.hideLoadingIndicator()
                if let error = error {
                    print(error.localizedDescription)
                    strongSelf.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: error.localizedDescription, onDismiss: { })
                    return
                } else {
                    var message = [String: Any]()
                    message["id"] = Auth.auth().currentUser?.uid ?? ""
                    message["email"] = Auth.auth().currentUser?.email
                    
                    let user = Mapper<UserInfo>().map(JSON: message as [String : AnyObject])
                    UserInfo.curentUser = user
                    
                    AppDelegate.instance().makingRootFlow(Constant.AppRootFlow.kEnterApp)
                }
            }
        }
    }
    
    @IBAction func btnGoogleTapped(_ sender: Any) {
        /*
         if let vcParent : LoginParentVC = self.parent as? LoginParentVC {
         vcParent.signInWithGoogle()
         }*/
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        let vcLoginParent : LoginVC = Constant.AppStoryboard.UserAuth.instance.instantiateViewController()
               self.navigationController?.pushViewController(vcLoginParent, animated: true)
//        if let vcParent : LoginParentVC = self.parent as? LoginParentVC {
//            vcParent.displayPage(0, animate: true)
//        }
    }
    
}
