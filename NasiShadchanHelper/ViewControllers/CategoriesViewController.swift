//
//  CategoriesViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

class CategoriesViewController: UIViewController {
    
    var ref: DatabaseReference!
    var messages = [[String: Any]]()
    
    var arrGirlsList = [NasiGirlsList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchList()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshResearchList(notificationReceived:)), name: Constant.EventNotifications.notifRefreshList, object: nil)

        print("current user id", UserInfo.curentUser?.id ?? "")
    }
    
    // MARK:- Selectors
    @objc func refreshResearchList(notificationReceived : Notification) {
        print("here is notification Received")
        self.getResearchList()
        self.getSentList()
    }
    
    func fetchList() {
        self.view.showLoadingIndicator()
        ref = Database.database().reference()
        ref.child("NasiGirlsList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.view.hideLoadingIndicator()
            if ( snapshot.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var message = [String: Any]()
                for nasigirls_child in (snapshot.children) {
                    let user_snap = nasigirls_child as! DataSnapshot
                    let dict = user_snap.value as! [String: String?]
                    
                    if let strDOB = dict["dateOfBirth"] {
                        print("here is exist")
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "MM-dd-yyyy"
                        let someDate = strDOB
                        if dateFormatterGet.date(from: someDate!) != nil {
                            // valid format
                            let age = calculateAgeFrom(dobString: dict["dateOfBirth"]! ?? "")
                            print("valid format valid formatvalid format",age)
                            message["dateOfBirth"] = age
                            
                        } else {
                            // invalid format
                            message["dateOfBirth"] = 0.0
                            print("invalid format")
                        }
                        
                    } else {
                        message["dateOfBirth"] = 0
                        // print("here is not exist")
                    }
                    
                    message["briefDescriptionOfWhatGirlIsLike"] = dict["briefDescriptionOfWhatGirlIsLike"] as? String
                    message["briefDescriptionOfWhatGirlIsLookingFor"] = dict["briefDescriptionOfWhatGirlIsLookingFor"] as? String
                    message["category"] = dict["category"] as? String
                    message["cellNumberOfContactToReddShidduch"] = dict["cellNumberOfContactToReddShidduch"] as? String
                    message["cellNumberOfContactWhoKNowsGirl"] = dict["cellNumberOfContactWhoKNowsGirl"] as? String
                    message["cityOfResidence"] = dict["cityOfResidence"] as? String
                    message["currentGirlUID"] = dict["currentGirlUID"] as? String
                    message["documentDownloadURLString"] = dict["documentDownloadURLString"] as? String
                    message["emailOfContactToReddShidduch"] = dict["emailOfContactToReddShidduch"] as? String
                    message["emailOfContactWhoKnowsGirl"] = dict["emailOfContactWhoKnowsGirl"] as? String
                    message["firstNameOfGirl"] = dict["firstNameOfGirl"] as? String
                    message["firstNameOfPersonToContactToReddShidduch"] = dict["firstNameOfPersonToContactToReddShidduch"] as? String
                    message["fullhebrewNameOfGirlAndMothersHebrewName"] = dict["fullhebrewNameOfGirlAndMothersHebrewName"] as? String
                    message["girlsCellNumber"] = dict["girlsCellNumber"] as? String
                    message["girlsEmailAddress"] = dict["girlsEmailAddress"] as? String
                    message["heightInFeet"] = dict["heightInFeet"] as? String
                    message["heightInInches"] = dict["heightInInches"] as? String
                    message["imageDownloadURLString"] = dict["imageDownloadURLString"] as? String
                    message["lastNameOfGirl"] = dict["lastNameOfGirl"] as? String
                    message["lastNameOfPersonToContactToReddShidduch"] = dict["lastNameOfPersonToContactToReddShidduch"] as? String
                    message["middleNameOfGirl"] = dict["middleNameOfGirl"] as? String
                    message["nameSheIsCalledOrKnownBy"] = dict["nameSheIsCalledOrKnownBy"] as? String
                    message["plan"] = dict["plan"] as? String
                    message["relationshipOfThisContactToGirl"] = dict["relationshipOfThisContactToGirl"] as? String
                    message["seminaryName"] = dict["seminaryName"] as? String
                    message["stateOfResidence"] = dict["stateOfResidence"] as? String
                    message["yearsOfLearning"] = dict["yearsOfLearning"] as? String
                    message["zipCode"] = dict["zipCode"] as? String
                    message["firstNameOfAContactWhoKnowsGirl"] = dict["firstNameOfAContactWhoKnowsGirl"] as? String
                    message["girlFamilyBackground"] = dict["girlFamilyBackground"] as? String
                    message["girlFamilySituation"] = dict["girlFamilySituation"] as? String
                    message["koveahIttim"] = dict["koveahIttim"] as? String
                    message["lastNameOfAContactWhoKnowsGirl"] = dict["lastNameOfAContactWhoKnowsGirl"] as? String
                    message["livingInIsrael"] = dict["livingInIsrael"] as? String
                    
                    message["professionalTrack"] = dict["professionalTrack"] as? String
                    self.messages.append(message)
                }
                
                if self.messages.count > 0 {
                    let model = Mapper<NasiGirlsList>().mapArray(JSONArray: self.messages as [[String : AnyObject]])
                    self.arrGirlsList = model
                    print("here is model", self.arrGirlsList.toJSON())
                    Variables.sharedVariables.arrList = self.arrGirlsList
                    self.setBadgeCount()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBadgeCount()
        Variables.sharedVariables.arrayForResearchList.removeAll()
        self.getResearchList()
        self.getSentList()
    }
    
    func setBadgeCount() {
        if let tabItems = self.tabBarController?.tabBar.items {
            if arrGirlsList.count > 0 {
                let tabItem = tabItems[0]
                tabItem.badgeValue = "\(arrGirlsList.count)" // set Badge count you need
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowFullTimeYeshiva" {
            Analytics.logEvent("categories_action", parameters: [
                "item_name": "Full Time Yeshiva",
            ])
            
            let controller = segue.destination as! FullTimeYeshivaViewController
            controller.arrGirlsList = arrGirlsList
        } else if segue.identifier == "ShowFullTimeCollege/Working" {
            Analytics.logEvent("categories_action", parameters: [
                "item_name": "Full Time College/Working",
            ])
            
            let controller = segue.destination as! FullTimeCollegeWorkingViewController
            controller.arrGirlsList = arrGirlsList
        } else if segue.identifier  == "ShowYeshivaAndCollege/Working" {
            Analytics.logEvent("categories_action", parameters: [
                "item_name": "Yeshiva And College/Working",
            ])
            
            let controller = segue.destination as! YeshivaAndCollegeWorkingViewController
            controller.arrGirlsList = arrGirlsList
        }
    }
}

// MARK:- IBActions
extension CategoriesViewController {
    @IBAction func btnlogoutAction(_ sender: Any) {
        
        let alertControler = UIAlertController.init(title:"Logout", message: Constant.ValidationMessages.msgLogout, preferredStyle:.alert)
        alertControler.addAction(UIAlertAction.init(title:"Yes", style:.default, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            UserInfo.resetCurrentUser()
            AppDelegate.instance().makingRootFlow(Constant.AppRootFlow.kAuthVc)
        }))
        alertControler.addAction(UIAlertAction.init(title:"No", style:.destructive, handler: { (action) in
        }))
        self.present(alertControler,animated:true, completion:nil)
    }
}

extension CategoriesViewController {
    func getResearchList() {
        // self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        ref.child("research").child(myId).observe(.childAdded) { (snapShots) in
            // self.view.hideLoadingIndicator()
            let snap = snapShots.value as? [String : Any]
            if (snapShots.value is NSNull ) {
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    Variables.sharedVariables.arrayForResearchList.append(dict["userId"]!)
                } else {
                }
            }
        }
    }
    
    func getSentList() {
        //self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        ref.child("sentsegment").child(myId).observe(.childAdded) { (snapShots) in
            // self.view.hideLoadingIndicator()
            let snap = snapShots.value as? [String : Any]
            if (snapShots.value is NSNull ) {
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    Variables.sharedVariables.arrayForResearchList.append(dict["userId"]!)
                } else {
                }
            }
        }
    }
}
