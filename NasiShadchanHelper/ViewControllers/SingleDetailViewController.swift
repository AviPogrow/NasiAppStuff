//
//  SingleDetailViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/25/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
protocol reloadDataDelegate {
    func reloadData(isTrue : Bool)
}
class SingleDetailViewController: UITableViewController {
    
    var selectedSingle: NasiGirlsList!
    @IBOutlet weak var lookingForLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var familySituationLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactCellLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    
    var lastName: String = ""
    var ref: DatabaseReference!
    var favChildArr = [[String : String]]()
    var arrFavGirlsList = [NasiGirlsList]()
    
    var isFavourite : Bool = false
    var strChildKey : String?
    var isFromFav : Bool = false
    var delegate : reloadDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(selectedSingle.firstNameOfGirl ?? "")" + " " + "\(selectedSingle.lastNameOfGirl ?? "")"
        
        if (selectedSingle!.briefDescriptionOfWhatGirlIsLike != nil) && selectedSingle.briefDescriptionOfWhatGirlIsLookingFor != nil {
            lookingForLabel.text = selectedSingle.briefDescriptionOfWhatGirlIsLookingFor!
            descriptionLabel.text = selectedSingle.briefDescriptionOfWhatGirlIsLike
        } else {
            lookingForLabel.text = "Placeholder for nil"
            descriptionLabel.text = "Placeholder for nil"
        }
        
        lastName = selectedSingle.lastNameOfGirl ?? ""
        
        if (selectedSingle.imageDownloadURLString ?? "").isEmpty {
            detailImageView?.image = UIImage.init(named: "placeholder")
        } else {
            detailImageView.loadImageFromUrl(strUrl: String(format: "%@",selectedSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        print("here is", selectedSingle.documentDownloadURLString ?? "")
        /*
         contactCellLabel.text = selectedSingle.contactCell
         contactNameLabel.text = selectedSingle.contactName
         contactEmailLabel.text = selectedSingle.contactEmail
         */
        
        /*
         contactCellLabel.text = selectedSingle.cellNumberOfContactToReddShidduch
         contactNameLabel.text = selectedSingle.firstNameOfAContactWhoKnowsGirl
         contactEmailLabel.text = selectedSingle.emailOfContactToReddShidduch
         familySituationLabel.text = selectedSingle.girlFamilyBackground
         */
        
        self.getFav()
    }
    
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setBackBtn()
    }
    
    
    func fetchAfterSave() {
        /*
         let lastNamePredicate = NSPredicate(format: "%K == %@", #keyPath(SingleGirl.lastName), selectedSingle.lastName)
         
         let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
         
         let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
         
         request.sortDescriptors = [ageSortDescriptor]
         
         request.predicate = lastNamePredicate
         
         do {
         let results =  try managedObjectContext.fetch(request)
         let firstResult = results.first
         let isSaved = firstResult?.isSaved
         print("firstResult is \(firstResult) and isSaved is \(firstResult?.isSaved)")
         } catch {
         print("error fetching core data")
         }*/
    }
    
    
    @IBAction func btnViewAllNotesTapped(_ sender: Any) {
        let vcNotesList = self.storyboard?.instantiateViewController(withIdentifier: "NotesListVC") as! NotesListVC
        vcNotesList.hidesBottomBarWhenPushed = true
        vcNotesList.girlId = selectedSingle.currentGirlUID
        self.navigationController?.pushViewController(vcNotesList, animated: true)
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
        if let url = URL(string: "tel:\( contactCellLabel.text)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func addNoteButtonTapped(_ sender: Any) {
        let vcAddNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesVC") as! AddNotesVC
        vcAddNotesVC.hidesBottomBarWhenPushed = true
        vcAddNotesVC.girlId = selectedSingle.currentGirlUID
        vcAddNotesVC.editNote = false
        self.navigationController?.pushViewController(vcAddNotesVC, animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if isFavourite {
            if strChildKey != nil {
                self.removeFav()
            }
        } else {
            self.saveToFav()
        }
    }
    
    func authLogin() {
        let stryBoardAuth : UIStoryboard = UIStoryboard.init(name: "UserAuthentication", bundle: nil)
        let vcNav : AuthNavViewController = stryBoardAuth.instantiateViewController(withIdentifier: "AuthNavViewController") as! AuthNavViewController
        vcNav.providesPresentationContextTransitionStyle = true
        vcNav.definesPresentationContext = true
        vcNav.modalPresentationStyle = UIModalPresentationStyle.overFullScreen;
        self.present(vcNav, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
    }
    
    func saveToFav() {
        self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        
        let dict = ["userId" : selectedSingle.currentGirlUID ?? "jonny"]
        ref.child("myFav").child(myId).childByAutoId().setValue(dict) { (error, ref) in
            self.view.hideLoadingIndicator()
            if error != nil {
                //print(error?.localizedDescription ?? “”)
            } else{
                //print(ref.key)
            }
        }
    }
    
    
    func removeFav(){
        self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard
            let keyPath = strChildKey,
            let myId = UserInfo.curentUser?.id
            else {
                print("invalid myID/keypath")
                return
        }
        ref.child("myFav").child(myId).child(keyPath).removeValue { (error, dbRef) in
            self.view.hideLoadingIndicator()
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(dbRef.key)
                self.isFavourite = false
                self.saveLabel.text = "Save to\nFavorites"
                self.saveLabel.textColor = Constant.AppColor.colorGrey
                // NotificationCenter.default.post(name: Constant.EventNotifications.notifRemoveFromFav, object: nil)
            }
            if self.isFromFav{
                self.delegate?.reloadData(isTrue: true)
            }else{
                self.delegate?.reloadData(isTrue: false)
            }
            //elf.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResume" {
            if (selectedSingle.documentDownloadURLString?.isEmpty)! {
                self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgDocumentUrlEmpty, onDismiss: {
                })
            } else {
                let controller = segue.destination as! ResumeViewController
                controller.selectedSingle = selectedSingle
            }
        }
    }
    
    func getFav() {
        self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        print("here is id", myId)
        ref.child("myFav").child(myId).observe(.childAdded) { (snapShots) in
            self.view.hideLoadingIndicator()
            self.favChildArr.removeAll()
            let snap = snapShots.value as? [String : Any]
            print(snap)
            if (snapShots.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    print(dict)
                    self.favChildArr.append(dict)
                    self.filterFavData()
                } else {
                    print("not a valid data")
                }
            }
        }
        
        if favChildArr.count > 0 {
        } else {
            self.view.hideLoadingIndicator()
        }
    }
    
    func filterFavData() {
        if favChildArr.count > 0 {
            print("here is fav child", favChildArr)
            print("here is fav child count", favChildArr.count)
            arrFavGirlsList.removeAll()
            
            let currentId = selectedSingle.currentGirlUID
            
            for (innerIndex,list) in favChildArr.enumerated() {
                let userId = list["userId"]
                let childKey = list["child_key"]
                print("here is user id", userId ?? "")
                print("here is child key", childKey ?? "")
                if currentId == userId {
                    strChildKey = childKey
                    saveButton.isEnabled = true
                    saveLabel.textColor = UIColor.red
                    saveLabel.text = "Already saved\nto favorites"
                    print("here is favouriteee")
                    isFavourite = true
                    break
                }
            }
            
            if isFavourite == false {
                isFavourite = false
                saveLabel.text = "Save to\nFavorites"
            }
            print("here is fav",arrFavGirlsList.count)
        } else {
            isFavourite = false
            saveLabel.text = "Save to\nFavorites"
            print("here is no fav child")
        }
    }
}




