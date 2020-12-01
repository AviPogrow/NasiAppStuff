//
//  MainResumeVC.swift
//  NasiShadchanHelper
//
//  Created by apple on 16/11/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import PDFKit
import Firebase
import MessageUI

class ResumeViewController: UITableViewController {
    var selectedSingle: NasiGirlsList!
    // Section 1
    @IBOutlet weak var imgVwUserDP: UIImageView!
    @IBOutlet weak var btnShareResumeOnly: UIButton!
    @IBOutlet weak var btnShareResumeAndPhoto: UIButton!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var lblNoResume: UILabel!

    var ref: DatabaseReference!
    var sentSegmentChildArr = [[String : String]]()
    var isAlreadyInSent:Bool = false
    var isAddedInResearch:Bool = false
    var strChildKey : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpProfilePhoto()
        self.setBackBarButton()
        self.setUpPDFView()
        self.getSentResumeList()
    }
    
    //TODO: Set Back Bar Button
    private func setBackBarButton() {
        let btn = UIBarButtonItem(image: UIImage.init(named: "imgBack"), style: .plain, target: self, action: #selector(back))
        btn.tintColor = .black
        self.navigationItem.leftBarButtonItem  = btn
    }
    
    func setUpPDFView() {
        if (selectedSingle.documentDownloadURLString?.isEmpty)! {
            lblNoResume.isHidden = false
        } else {
            lblNoResume.isHidden = true
            var document: PDFDocument!
            let pathURL = URL(string: selectedSingle.documentDownloadURLString ?? "")!
            document = PDFDocument(url: pathURL)
            
            if let document = document {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
                pdfView.document = document
            }
        }
    }
    
    //TODO: Back Button Action
    @objc func backBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //TODO: Initialize Data
    
    func savePDF ( _ fileName : String){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
        let fileURL = documentsURL.appendingPathComponent("\(fileName).pdf")

    }
    private func setUpProfilePhoto() {
        if (selectedSingle.imageDownloadURLString ?? "").isEmpty {
            imgVwUserDP?.image = UIImage.init(named: "placeholder")
        } else {
            imgVwUserDP.loadImageFromUrl(strUrl: String(format: "%@",selectedSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        
        btnShareResumeOnly.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
        btnShareResumeAndPhoto.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
    }
    
    func shareResumeOnly() {
        if (selectedSingle.documentDownloadURLString?.isEmpty)! {
            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgDocumentUrlEmpty, onDismiss: {
                           })
        } else {
            let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
            let resumeData = try! Data(contentsOf: url)
            
            
            let activityVC = UIActivityViewController(activityItems: [resumeData], applicationActivities: [])
            let subject =  "\("Resume")" + " "  + "\(selectedSingle.firstNameOfGirl ?? "")" + " "  + "\(selectedSingle.lastNameOfGirl ?? "")" //top 1 name

            activityVC.setValue(subject, forKey: "Subject")

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
    
    func shareResumeAndPhotos() {
        if (selectedSingle.imageDownloadURLString?.isEmpty)! {
            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgImageUrlEmpty, onDismiss: {
            })
        } else {
            let urlForImage = URL(string: selectedSingle.imageDownloadURLString ?? "")
            let imageData = try! Data(contentsOf: urlForImage!)
            
            
            let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
            let resumeData = try! Data(contentsOf: url)
            
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
            
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        let resumeData = try! Data(contentsOf: url)
        
        let urlForImage = URL(string: selectedSingle.imageDownloadURLString ?? "")
        let imageData = try! Data(contentsOf: urlForImage!)
        
        let activityVC = UIActivityViewController(activityItems: [imageData,resumeData], applicationActivities: [])
        // activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.barButtonItem = sender
        activityVC.setValue("This is my title", forKey: "Subject")

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
                        self.isAlreadyInSent = true
                    }
                } else {
                    print("not a valid data")
                }
            }
        }
        
    }

}

// ----------------------------------
// MARK: - BUTTION ACTION(S) -
//
extension ResumeViewController {
    @IBAction func btnShareResumeTapped(_ sender: Any) {
        self.shareResumeOnly()
        if isAddedInResearch {
            self.removeFav()
        }
        self.saveToSentSegment()
       // self.showActionSheet()
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "Nasi", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Send resume only via email", style: .default , handler:{ (UIAlertAction)in //Save Profile
        }))
        
        alert.addAction(UIAlertAction(title: "Save to phone", style: .default , handler:{ (UIAlertAction)in //Save Profile
               }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func btnShareResumePhotoTapped(_ sender: Any) {
        self.shareResumeAndPhotos()
        if isAddedInResearch {
            self.removeFav()
        }
        self.saveToSentSegment()
    }
    
    func saveToSentSegment() {
        if isAlreadyInSent {
            return
        }
        
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        
        let dict = ["userId" : selectedSingle.currentGirlUID ?? "jonny"]
        ref.child("sentsegment").child(myId).childByAutoId().setValue(dict) { (error, ref) in
            if error != nil {
                //print(error?.localizedDescription ?? “”)
            } else{
                NotificationCenter.default.post(name: Constant.EventNotifications.notifRemoveFromFav, object: ["updateStatus":"sentList"])
                NotificationCenter.default.post(name: Constant.EventNotifications.notifRefreshNasiList, object: ["updateCurrentGirlId":self.selectedSingle.currentGirlUID ?? "jonny"])
                 NotificationCenter.default.post(name: Constant.EventNotifications.notifRefreshList, object: nil)

               // NotificationCenter.default.post(name: Constant.EventNotifications.notifRemoveFromFav, object: ["updateStatus":"researchList"])
                Analytics.logEvent("added_in_favouriteList", parameters: [
                    "selected_item_name": self.selectedSingle.firstNameOfGirl ?? "",
                ])
            }
        }
    }
    
    func removeFav() {
//        if strChildKey?.isEmpty {
//
//        }
        ref = Database.database().reference()
        guard
            let keyPath = strChildKey,
            let myId = UserInfo.curentUser?.id
            else {
                print("invalid myID/keypath")
                return
        }
        ref.child("research").child(myId).child(keyPath).removeValue { (error, dbRef) in
            self.view.hideLoadingIndicator()
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(dbRef.key)
                 NotificationCenter.default.post(name: Constant.EventNotifications.notifRemoveFromFav, object: nil)
            }
            
            /*
            if self.isFromFav{
                self.delegate?.reloadData(isTrue: true)
            }else{
                self.delegate?.reloadData(isTrue: false)
            }*/
            
        }
    }

}

// ----------------------------------
// MARK: - TableView Delegate(S) -
//
extension ResumeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                //   self.shareResumeOnly()
            } else if indexPath.row == 2 {
                // self.shareResumeAndPhotos()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else if indexPath.row == 1 {
                return 310
            } else {
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
}

// MARK:- MFMailCompose ViewController Delegate
extension ResumeViewController : MFMailComposeViewControllerDelegate {

   // MARK: Open MailComposer
   func sendEmail(_ emailRecipients:String) {
       let vcMailCompose = MFMailComposeViewController()
       vcMailCompose.mailComposeDelegate = self
       vcMailCompose.setToRecipients([emailRecipients])
       let subject =  "\("Resume")" + " "  + "\(selectedSingle.firstNameOfGirl ?? "")" + " "  + "\(selectedSingle.lastNameOfGirl ?? "")" //top 1 name
       vcMailCompose.setSubject(subject)
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
