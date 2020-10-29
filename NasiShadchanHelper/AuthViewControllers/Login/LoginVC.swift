//
//  LoginVC.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//


import UIKit
import Firebase
import GoogleSignIn
import ObjectMapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var tfEmail: AlignedPlaceholderTextField!
    @IBOutlet weak var tfPassword: AlignedPlaceholderTextField!
    @IBOutlet weak var heightImageView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    //MARK: UI Setup
    func setupUI() {
        self.viewForm.roundViewTopEdges(radius: 15)
        self.tfEmail.addLeftPadding()
        self.tfPassword.addLeftPadding()
        
        if AppDelegate.instance().window?.frame.size.height ?? 0.0 < 600.0 {
            self.heightImageView.constant = 220
        } else {
            self.heightImageView.constant = (AppDelegate.instance().window?.frame.size.height)! - (Utility.hasTopNotch ? 550 : 410)
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
        
        #if DEBUG
        self.tfEmail.text = "softradix456@gmail.com"
        //"softradix454545@gmail.com"
        //"softradix@gmail.com"
        self.tfPassword.text = "qwertyuiop"
         #endif
        self.view.layoutIfNeeded()
    }
    
    //MARK: Validaitons
    func validateFormFields() -> Bool {
        self.tfEmail.validate(); self.tfPassword.validate()
        if self.tfEmail.validate() && self.tfPassword.validate() {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    /* If the email exists, then
     a. Download the customer record. Use the <EntityKey> returned from the Validate Email call previously. b. Download order history (optional)
     c. Transition to the Service Order screen
     4. Otherwise, if the email does not exist, then
     a. Create the customer record. See Create Customer (Concierr Only)
     b. Transition to the customer account screen where the user can make modifications to their account as needed. c. After customer saves the account information, transition to the Service Order Screen.
     */
    //MARK: IBActions
    @IBAction func btnLoginTapped(_ sender: Any) {
        
        if validateFormFields() { //Login
            self.view.showLoadingIndicator()
            Auth.auth().signIn(withEmail: tfEmail.text ?? "", password: tfPassword.text ?? "") { [weak self] user, error in
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
                    
                    // print(user?.additionalUserInfo)
                }
            }
        }
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        askForCustomerEmailAddress()
    }
    
    func askForCustomerEmailAddress() {
        
        let alertController = UIAlertController(title: "Email", message: "You will receive password recovery link on this email", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
            textField.textAlignment = .left
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text?.count == 0 {
                self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgEmailEmpty, onDismiss: { })
            }else {
                if firstTextField.text!.isValidEmail() {
                    self.view.showLoadingIndicator()
                    Auth.auth().sendPasswordReset(withEmail: firstTextField.text ?? "") { error in
                        self.view.hideLoadingIndicator()
                        if let error = error {
                            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: error.localizedDescription, onDismiss: { })
                            return
                        } else {
                            self.showAlert(title: Constant.ValidationMessages.successTitle, msg: Constant.ValidationMessages.msgSentPassword, onDismiss: { })
                        }
                    }
                }else {
                    self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgEmailInvalid, onDismiss: { })
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { alert -> Void in  })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnGoogleTapped(_ sender: Any) {
        if let vcParent : LoginParentVC = self.parent as? LoginParentVC {
            // vcParent.signInWithGoogle()
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        if let vcParent : LoginParentVC = self.parent as? LoginParentVC {
            vcParent.displayPage(1, animate: true)
        }
    }
}


