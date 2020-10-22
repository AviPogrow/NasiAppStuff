//
//  AddNotesVC.swift
//  NasiShadchanHelper
//
//  Created by apple on 08/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import Firebase

protocol reloadNoteDelegate {
    func reloadNotes()
}

class AddNotesVC: UIViewController {
    @IBOutlet weak var txtVw: KMPlaceholderTextView!
    @IBOutlet weak var btnDone: UIButton!
    var ref: DatabaseReference!
    
    var delegate : reloadNoteDelegate?
    var girlId : String?
    var editNote : Bool = false
    var prevData = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackBtn()
        btnDone?.setCornerRadius(radius: 8, colorBorder: .clear)
        txtVw.layer.cornerRadius = 10.0
        txtVw.layer.borderWidth = 1.0
        txtVw.layer.borderColor = UIColor.lightGray.cgColor
        txtVw.backgroundColor = UIColor.white
        txtVw.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if editNote {
            txtVw.text = prevData["note"] ?? ""
            btnDone.setTitle("Update Note", for: .normal)
        }else{
            txtVw.text = ""
            btnDone.setTitle("Done", for: .normal)
        }
    }
    
     // MARK:- Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

//MARK: IBActions
extension AddNotesVC {
    @IBAction func btnNotesTapped(_ sender: Any) {
        if txtVw.text.isEmpty {
            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgNotesEmpty) {
            }
        } else {
            //            self.navigationController?.popViewController(animated: true)
            guard
                let myId = UserInfo.curentUser?.id,
                let gId = girlId,
                let note = txtVw.text
                else {
                    print("data nil")
                    return
            }
            let dict = ["userId":gId,"note":note]
            ref = Database.database().reference()
            if editNote {
                guard let noteKey = prevData["key"] else { return }
                ref.child("favUserNotes").child(myId).child(noteKey).updateChildValues(dict) { (error, dbRef) in
                    if error != nil {
                        print( error?.localizedDescription ?? "")
                    }else{
                        print("success")
                        print(dbRef.key ?? "dbKey")
                        self.delegate?.reloadNotes()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                ref.child("favUserNotes").child(myId).childByAutoId().setValue(dict) { (error, dbRef) in
                    if error != nil {
                        print( error?.localizedDescription ?? "")
                    }else{
                        print("success")
                        print(dbRef.key ?? "dbKey")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func updateNote(){
        
    }
}

