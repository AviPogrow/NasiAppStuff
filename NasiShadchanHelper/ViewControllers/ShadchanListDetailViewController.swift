 //
 //  ShadchanListDetailViewController.swift
 //  NasiShadchanHelper
 //
 //  Created by user on 5/29/20.
 //  Copyright © 2020 user. All rights reserved.
 //
 
 import UIKit
 import KMPlaceholderTextView
 import Firebase
 import Lightbox
 import MessageUI
 
 class ShadchanListDetailViewController: UITableViewController {
    // ----------------------------------
    // MARK: - IB-OUTLET(S)
    //
    // Section 1
    @IBOutlet weak var imgVwUserDP: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var notesTextView: KMPlaceholderTextView!
    @IBOutlet weak var btnShareResumeOnly: UIButton!
    @IBOutlet weak var btnShareResumeAndPhoto: UIButton!
    @IBOutlet weak var vwBgForAddPhoto: UIView!
    @IBOutlet weak var imgVwAddMore: UIImageView!
    @IBOutlet weak var imgPlusIcn: UIImageView!
    @IBOutlet weak var lblAddMore: UILabel!
    @IBOutlet weak var btnCamera: UIButton!
    
    // Section 2
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblMiddleName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    //Section 3
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblHeightft: UILabel!
    @IBOutlet weak var lblFamilySituation: UILabel!
    @IBOutlet weak var lblYearItOccurred: UILabel!
    @IBOutlet weak var lblGirlsCellNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    
    //Section 4
    @IBOutlet weak var lblSeminary: UILabel!
    @IBOutlet weak var lblLookingForBriefDescrp: UILabel!
    @IBOutlet weak var lblBriefDescrp: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblLivingInIsrael: UILabel!
    @IBOutlet weak var lblFamilyBg: UILabel!
    
    //Section 5
    @IBOutlet weak var lblLastNameToRed: UILabel!
    @IBOutlet weak var lblFirstNameToRed: UILabel!
    @IBOutlet weak var lblCellNumberToRed: UILabel!
    @IBOutlet weak var lblEmailToRed: UILabel!
    
    //Section 6
    @IBOutlet weak var lblContactLastName: UILabel!
    @IBOutlet weak var lblContactFirstName: UILabel!
    @IBOutlet weak var lblContactCell: UILabel!
    @IBOutlet weak var lblContactEmail: UILabel!
    @IBOutlet weak var lblContactRelationshipToSingle: UILabel!
    
    var ref: DatabaseReference!
    var image: UIImage?
    var selectedSingle: NasiGirlsList!
    var isAlreadyAddedNotes:Bool = false
    var favChildArr = [[String : String]]()
     var strChildKey : String?
    
    // ----------------------------------
    // MARK: - View Loading -
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getResearchList()
        self.getSentResumeList()
        self.setBackBarButton()
        self.getFavUserNote()
        self.getPrevImages()
        // Hide keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        self.setUpProfilePhoto()
        self.setUpFirstSection()
        self.setUpSecondSection()
        self.setUpThirdSection()
        self.setUpForthSection()
        self.setUpFifthSection()
        self.addTapGestureInImg()
        self.btnCamera.isHidden = true
    }
    
    // ----------------------------------
    // MARK: - OVERRIDE METHOD(S) -
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // ----------------------------------
    // MARK: - Status Bar Style -
    //
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // ----------------------------------
    // MARK: - PRIVATE METHOD(S) -
    //
    
    //TODO: Set Back Bar Button
    private func setBackBarButton() {
        let btn = UIBarButtonItem(image: UIImage.init(named: "imgBack"), style: .plain, target: self, action: #selector(backBtnTapped))
        btn.tintColor = .black
        self.navigationItem.leftBarButtonItem  = btn
    }
    
    //TODO: Back Button Action
    @objc func backBtnTapped() {
        //self.navigationController?.popViewController(animated: true)
        if !self.isAlreadyAddedNotes {
            self.showActionSheet()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "Nasi", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Save Profile", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.isAlreadyAddedNotes = true
            self.saveToResearch()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func getResearchList() {
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        ref.child("research").child(myId).observe(.childAdded) { (snapShots) in
            self.view.hideLoadingIndicator()
            let snap = snapShots.value as? [String : Any]
            if (snapShots.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    print(dict)
                     self.favChildArr.append(dict)
                    if self.selectedSingle.currentGirlUID == dict["userId"] {
                        self.isAlreadyAddedNotes = true
                    }
                    self.filterFavData()
                } else {
                    print("not a valid data")
                }
            }
        }
    }
    
    func filterFavData() {
        if favChildArr.count > 0 {
            print("here is fav child", favChildArr)
            print("here is fav child count", favChildArr.count)
            
            let currentId = selectedSingle.currentGirlUID
            
            for (innerIndex,list) in favChildArr.enumerated() {
                let userId = list["userId"]
                let childKey = list["child_key"]
                print("here is user id", userId ?? "")
                print("here is child key", childKey ?? "")
                if currentId == userId {
                    strChildKey = childKey
                    break
                }
            }
            
        }
    }

    
    func getSentResumeList() {
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        print("here is id", myId) //"myFav"
        ref.child("sentsegment").child(myId).observe(.childAdded) { (snapShots) in
            if (snapShots.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    print(dict)
                    if self.selectedSingle.currentGirlUID == dict["userId"] {
                        self.isAlreadyAddedNotes = true
                    }
                } else {
                    print("not a valid data")
                }
            }
        }
        
    }
    
    //TODO: Initialize Data
    private func setUpProfilePhoto() {
        if (selectedSingle.imageDownloadURLString ?? "").isEmpty {
            imgVwUserDP?.image = UIImage.init(named: "placeholder")
        } else {
            imgVwUserDP.loadImageFromUrl(strUrl: String(format: "%@",selectedSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        
        lblFullName?.text =  "\(selectedSingle.firstNameOfGirl ?? "")" + " "  + "\(selectedSingle.lastNameOfGirl ?? "")" //top 1 name
        
        btnShareResumeOnly.addRoundedViewCorners(width: 8, colorBorder: Constant.AppColor.colorAppTheme)
        btnShareResumeAndPhoto.addRoundedViewCorners(width: 8, colorBorder: Constant.AppColor.colorAppTheme)
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.borderWidth = 1.0
        notesTextView.layer.cornerRadius = 5.0
        
        notesTextView.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        vwBgForAddPhoto.addRoundedViewCorners(width: 12, colorBorder: .lightGray)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(openGalleryPicker))
        gestureRecognizer.cancelsTouchesInView = false
        vwBgForAddPhoto.addGestureRecognizer(gestureRecognizer)
    }
    
    //TODO: SetUp Data For Girls name Section
    private func setUpFirstSection() {
        lblFirstName?.text = selectedSingle.firstNameOfGirl ?? ""
        lblMiddleName.text = selectedSingle.middleNameOfGirl ?? ""
        lblLastName.text = selectedSingle.lastNameOfGirl ?? ""
        lblName.text = selectedSingle.nameSheIsCalledOrKnownBy ?? ""
        
        if (selectedSingle!.nameSheIsCalledOrKnownBy != nil) {
            lblName.text = (selectedSingle.nameSheIsCalledOrKnownBy ?? "") + (selectedSingle.lastNameOfGirl ?? "")
        } else {
            lblName.text = (selectedSingle.firstNameOfGirl ?? "") + (selectedSingle.lastNameOfGirl ?? "")
        }
        
    }
    
    //TODO: SetUp Data For Girls details Section
    private func setUpSecondSection() {
        lblDob?.text = "\(selectedSingle.dateOfBirth ?? 0.0)"
        lblFamilySituation.text = selectedSingle.girlFamilySituation ?? ""
        //lblYearItOccurred.text = selectedSingle.yearsOfLearning ?? ""
        lblGirlsCellNumber.text = selectedSingle.girlsCellNumber ?? ""
        lblAddress.text = "Address - Need to discuss"
        lblCity.text = selectedSingle.cityOfResidence ?? ""
        lblState.text = selectedSingle.stateOfResidence ?? ""
        lblZip.text = selectedSingle.zipCode ?? ""
        
        let heightInFt = selectedSingle.heightInFeet ?? ""
        let heightInInches = selectedSingle.heightInInches ?? ""
        let height = "\(heightInFt)\'" + "\(heightInInches)\""
        lblHeightft.text = height
        
    }
    
    //TODO: SetUp Data For Shidduch details Section
    private func setUpThirdSection() {
        lblSeminary?.text = "\(selectedSingle.seminaryName ?? "")"
        lblLookingForBriefDescrp?.text = "\(selectedSingle.briefDescriptionOfWhatGirlIsLookingFor ?? "")"
        lblBriefDescrp?.text = "\(selectedSingle.briefDescriptionOfWhatGirlIsLookingFor ?? "")"
        lblPlan?.text = "\(selectedSingle.plan ?? "")"
        lblLivingInIsrael?.text = "\(selectedSingle.livingInIsrael ?? "")"
        lblFamilyBg?.text = "\(selectedSingle.girlFamilyBackground ?? "")"
    }
    
    //TODO: SetUp Data For To redd a shidduch Section
    private func setUpForthSection() {
        lblLastNameToRed?.text = "\(selectedSingle.lastNameOfPersonToContactToReddShidduch ?? "")"
        lblFirstNameToRed?.text = "\(selectedSingle.firstNameOfPersonToContactToReddShidduch ?? "")"
        lblCellNumberToRed.text = selectedSingle.cellNumberOfContactToReddShidduch ?? ""
        lblEmailToRed.text = selectedSingle.emailOfContactToReddShidduch
    }
    
    //TODO: SetUp Data For To discuss a shidduch Section
    private func setUpFifthSection() {
        lblContactLastName?.text = "\(selectedSingle.lastNameOfAContactWhoKnowsGirl ?? "")"
        lblContactFirstName?.text = "\(selectedSingle.firstNameOfAContactWhoKnowsGirl ?? "")"
        lblContactCell.text = selectedSingle.cellNumberOfContactWhoKNowsGirl ?? ""
        lblContactEmail.text = selectedSingle.emailOfContactWhoKnowsGirl ?? ""
        lblContactRelationshipToSingle.text = selectedSingle.relationshipOfThisContactToGirl ?? ""
    }
    
    private func addTapGestureInImg() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(openImageView))
        imgVwAddMore.isUserInteractionEnabled = true
        imgVwAddMore.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func openImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        self.openMediaViewer(selectedIndex: 0)
    }
    
    
    @objc func openGalleryPicker(_ gestureRecognizer: UIGestureRecognizer) {
        self.showPhotoMenu()
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        if notesTextView.text.isEmpty {
            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgNotesEmpty) {
            }
        } else {
            guard
                let myId = UserInfo.curentUser?.id,
                let gId = selectedSingle.currentGirlUID,
                let note = notesTextView.text
                else {
                    print("data nil")
                    return
            }
            let dict = ["note":note]
            ref = Database.database().reference()
            ref.child("favUserNotes").child(myId).child(gId).setValue(dict) { (error, dbRef) in
                if error != nil {
                    print( error?.localizedDescription ?? "")
                }else{
                    print("success")
                    print(dbRef.key ?? "dbKey")
                }
            }
        }
        
        if !self.isAlreadyAddedNotes {
            self.saveToResearch()
        }
    }
    
    func saveToResearch() {
        self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        
        let dict = ["userId" : selectedSingle.currentGirlUID ?? "jonny"]
        ref.child("research").child(myId).childByAutoId().setValue(dict) { (error, ref) in
            self.view.hideLoadingIndicator()
            self.isAlreadyAddedNotes = true
            self.navigationController?.popViewController(animated: true)
            if error != nil {
                //print(error?.localizedDescription ?? “”)
            } else{
                
                Analytics.logEvent("added_in_favouriteList", parameters: [
                    "selected_item_name": self.selectedSingle.firstNameOfGirl ?? "",
                ])
            }
        }
    }
    
    
    
    func getFavUserNote() {
        guard
            let myId = UserInfo.curentUser?.id,
            let gID = selectedSingle.currentGirlUID
            else {
                print("data nil")
                return
        }
        ref = Database.database().reference()
        ref.child("favUserNotes").child(myId).child(gID).observe(.childAdded) { (snapShot) in
            if let noteStr = snapShot.value as? String {
                print("notes txt :- \(noteStr)")
                self.notesTextView.text = noteStr
                self.isAlreadyAddedNotes = true
            }else{
                print("invalid data")
            }
            print("user notes :-")
        }
    }
    
    func getPrevImages() {
        guard
            let myId = UserInfo.curentUser?.id,
            let gID = self.selectedSingle.currentGirlUID
            else {
                print("data nil")
                return
        }
        ref = Database.database().reference()
        ref.child("favUserPhotos").child(myId).child(gID).observe(.childAdded) { (snapShot) in
            if let snap = snapShot.value as? String {
                print("imgUrl :- \(snap)")
                self.imgVwAddMore.isHidden = false
                self.imgPlusIcn.isHidden = true
                self.lblAddMore.isHidden = true
                self.btnCamera.isHidden = false
                self.imgVwAddMore.loadImageFromUrl(strUrl: String(format: "%@",snap), imgPlaceHolder: "placeholder")
            }else{
                print("invalid data")
            }
            print("user notes :-")
        }
        
        ref.child("favUserPhotos").child(myId).child(gID).observe(.childChanged) { (snapShot) in
            if let snap = snapShot.value as? String {
                print("imgUrl :- \(snap)")
            }else{
                print("invalid data")
            }
            print("user notes :-")
        }
        
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: tableView)
        
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil && indexPath!.section == 2
            && indexPath!.row == 0 {
            return
        }
        notesTextView.resignFirstResponder()
    }
    
    func openNotesListScreen() {
        let vcNotesList = self.storyboard?.instantiateViewController(withIdentifier: "NotesListVC") as! NotesListVC
        vcNotesList.hidesBottomBarWhenPushed = true
        vcNotesList.girlId = selectedSingle.currentGirlUID
        self.navigationController?.pushViewController(vcNotesList, animated: true)
    }
    
    func presentResumeViewController() {
        if (selectedSingle.documentDownloadURLString?.isEmpty)! {
            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgDocumentUrlEmpty, onDismiss: {
            })
        } else {
            let controller = storyboard!.instantiateViewController(withIdentifier: "ResumeViewController") as! ResumeViewController
            controller.selectedSingle = selectedSingle
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func show(image: UIImage) {
        imgVwAddMore.image = image
        imgVwAddMore.isHidden = false
        imgPlusIcn.isHidden = true
        lblAddMore.isHidden = true
        tableView.reloadData()
    }
 }
 // ----------------------------------
 // MARK: - UIActivityViewController -
 //
 extension ShadchanListDetailViewController {
    func shareResumeAndPhotos() {
        
        let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        let resumeData = try! Data(contentsOf: url)
        
        let urlForImage = URL(string: selectedSingle.imageDownloadURLString ?? "")
        let imageData = try! Data(contentsOf: urlForImage!)
        
        let activityVC = UIActivityViewController(activityItems: [imageData,resumeData], applicationActivities: [])
        //activityVC.popoverPresentationController?.barButtonItem = sender
        
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension")
        ]
        
        present(activityVC, animated: true, completion: nil)
        
        /*
         let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
         let resumeData = try! Data(contentsOf: url)
         
         let activityItem: [AnyObject] = [self.imgVwUserDP.image as! AnyObject]
         
         let avc = UIActivityViewController(activityItems: [activityItem as [AnyObject],selectedSingle.documentDownloadURLString ?? ""], applicationActivities: nil)
         
         self.present(avc, animated: true, completion: nil)
         */
        
    }
    
    func shareResumeOnly() {
        let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        let resumeData = try! Data(contentsOf: url)
        
        
        let activityVC = UIActivityViewController(activityItems: [resumeData], applicationActivities: [])
        //activityVC.popoverPresentationController?.barButtonItem = sender
        
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension")
        ]
        
        present(activityVC, animated: true, completion: nil)
        
    }
    
 }
 
 // ----------------------------------
 // MARK: - Button Action() -
 //
 extension ShadchanListDetailViewController {
    
    @IBAction func sendResumeTapped(_ sender: Any) {
        presentResumeViewController()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        /*
         let vcResume = self.storyboard?.instantiateViewController(withIdentifier: "ResumeViewController") as! ResumeViewController
         vcResume.selectedSingle = selectedSingle
         self.navigationController?.pushViewController(vcResume, animated: true)
         */
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ResumeViewController") as! ResumeViewController
        controller.selectedSingle = selectedSingle
        controller.strChildKey = strChildKey
        controller.isAddedInResearch = isAlreadyAddedNotes
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCameraTapped(_ sender: Any) {
        self.showPhotoMenu()
    }
    
 }
 
 // ----------------------------------
 // MARK: - TableView Delegate(S) -
 //
 extension ShadchanListDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 4 {
                self.shareResumeOnly()
            } else if indexPath.row == 5 {
                self.shareResumeAndPhotos()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 3 {
                if (selectedSingle.girlsCellNumber != nil) {
                    Utility.makeACall(selectedSingle.girlsCellNumber!)
                }
            }
        } else if indexPath.section == 4 {
            print("hrer is 4")
            if indexPath.row == 2 {
                if (selectedSingle!.cellNumberOfContactToReddShidduch != nil) {
                    Utility.makeACall(selectedSingle.cellNumberOfContactToReddShidduch!)
                }
            } else if indexPath.row == 3 {
                if (selectedSingle.emailOfContactToReddShidduch != nil) {
                    sendEmail(selectedSingle.emailOfContactToReddShidduch!)
                }
            }
        } else if indexPath.section == 5 {
            if indexPath.row == 2 {
                if (selectedSingle!.cellNumberOfContactWhoKNowsGirl != nil) {
                    Utility.makeACall(selectedSingle.cellNumberOfContactWhoKNowsGirl!)
                }
            } else if indexPath.row == 3 {
                if (selectedSingle.emailOfContactWhoKnowsGirl != nil) {
                    sendEmail(selectedSingle.emailOfContactWhoKnowsGirl!)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2  || indexPath.section == 3 || indexPath.section == 4  || indexPath.section == 5 {
            return UITableView.automaticDimension
        } else if indexPath.section == 8 {
            return 60
        } else if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 225
            } else if indexPath.row == 1 {
                return 60
            } else if indexPath.row == 2 {
                return 160
            } else if indexPath.row == 3 {
                return 170
            } else if indexPath.row == 4 || indexPath.row == 5 {
                //return 100
                return 0
            }
        }
        return UITableView.automaticDimension
    }
 }
 
 // ----------------------------------
 // MARK: - UIImagePickerControllerDelegate -
 //
 extension ShadchanListDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let theImage = image {
            show(image: theImage)
            
            self.uploadImage(theImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlert(title: "Warning", msg: "You don't have camera", onDismiss: {
            })
        }
        /*
         let imagePicker = UIImagePickerController()
         imagePicker.sourceType = .camera
         imagePicker.delegate = self
         imagePicker.allowsEditing = true
         present(imagePicker, animated: true, completion: nil)
         */
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if true || UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    func uploadImage(_ img : UIImage) {
        uploadMedia(img) { (imgUrl) in
            guard
                let myId = UserInfo.curentUser?.id,
                let gId = self.selectedSingle.currentGirlUID,
                let iUrl = imgUrl
                else {
                    print("data nil")
                    return
            }
            let dict = ["imgUrl":iUrl]
            self.ref = Database.database().reference()
            self.ref.child("favUserPhotos").child(myId).child(gId).setValue(dict) { (error, dbRef) in
                if error != nil {
                    print( error?.localizedDescription ?? "")
                }else{
                    print("success")
                    print(dbRef.key ?? "dbKey")
                }
            }
        }
    }
    
    func uploadMedia(_ image : UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let str = df.string(from: Date())
        let riversRef = storageRef.child("images/Image_\(str).jpg")
        guard let uploadData = image.jpegData(compressionQuality: 0.25) else{
            print("image can’t be converted to data")
            return
        }
        self.view.showLoadingIndicator()
        let uploadTask = riversRef.putData(uploadData, metadata: nil) { (metadata, error) in
            self.view.hideLoadingIndicator()
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                print(error?.localizedDescription ?? "")
                return
            }
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                print("d1-\(downloadURL)")
                completion("\(downloadURL)")
            }
        }
        _ = uploadTask.observe(.progress) { snapshot in
            // A progress event occurred
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("progress- \(percentComplete)")
        }
    }
 }
 
 extension ShadchanListDetailViewController {
    func openMediaViewer(selectedIndex: Int) {
        var imageInfo = [LightboxImage]()
        imageInfo.removeAll()
        if imgVwAddMore.image != nil {
            imageInfo.append(LightboxImage(image: imgVwAddMore.image!))
        }
        let controller = LightboxController(images: imageInfo, startIndex: selectedIndex)
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
 }
 
 // MARK:- MFMailCompose ViewController Delegate
 extension ShadchanListDetailViewController : MFMailComposeViewControllerDelegate {
    
    // MARK: Open MailComposer
    func sendEmail(_ emailRecipients:String) {
        let vcMailCompose = MFMailComposeViewController()
        vcMailCompose.mailComposeDelegate = self
        vcMailCompose.setToRecipients([emailRecipients])
        vcMailCompose.setSubject("Nasi - iOS Mobile App")
        
        let strMailBody = "Please type your question here:\n\n\n"
        vcMailCompose.setMessageBody(strMailBody, isHTML: false)
        self.present(vcMailCompose, animated: true) {}
    }
    
    // MARK: MailComposer Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            switch result {
            case .sent:
                self.showAlert(title: Constant.ValidationMessages.successTitle, msg:Constant.ValidationMessages.mailSentSuccessfully, onDismiss: {})
            case .saved:
                self.showAlert(title: Constant.ValidationMessages.successTitle, msg:Constant.ValidationMessages.mailSavedSuccessfully, onDismiss: {})
            case .failed:
                self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg:Constant.ValidationMessages.mailFailed, onDismiss: {})
            default: break
            }
        }
    }
 }
