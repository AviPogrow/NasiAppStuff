//
//  NotesListVC.swift
//  NasiShadchanHelper
//
//  Created by apple on 08/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase

class NotesListVC: UIViewController {
    
    @IBOutlet weak var tblVwNotes: UITableView!
    @IBOutlet weak var vwBgPlaceholder: UIView!
    var girlId : String?
    var ref: DatabaseReference!
    var notesArr = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.title = "Notes"
        getFavUserNotes()
    }
    
    func setUpUi() {
        tblVwNotes.register(NotesTableCell.self)
    }
    
    func getFavUserNotes() {
        self.view.showLoadingIndicator()
        guard
            let myId = UserInfo.curentUser?.id,
            let gID = girlId
            else {
                print("data nil")
                return
        }
        self.notesArr.removeAll()
        ref = Database.database().reference()
        ref.child("favUserNotes").child(myId).observe(.childAdded) { (snapShot) in
            self.view.hideLoadingIndicator()
            if var snap = snapShot.value as? [String : String] {
                snap["key"] = snapShot.key
                self.notesArr.append(snap)
            }else{
                print("invalid data")
            }
            print("user notes :-")
            let dict:[[String:String]] = self.notesArr.filter{($0["userId"] as! String) == gID}
            self.notesArr = dict
            // self.tblVwNotes.reloadData()
            self.displayDataInNotes()
        }
        
        if notesArr.count > 0 {
            
        } else {
            self.view.hideLoadingIndicator()
            self.displayDataInNotes()
        }
        
    }
    
    func displayDataInNotes() {
        if notesArr.count > 0 {
            self.tblVwNotes.isHidden = false
            self.vwBgPlaceholder.isHidden = true
            self.tblVwNotes.reloadData()
        } else {
            self.tblVwNotes.isHidden = true
            self.vwBgPlaceholder.isHidden = false
        }
    }
}

// MARK:- TableViewDelegates&Datasource
extension NotesListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableview(tableView, notesTableCell: indexPath)
    }
    
    func tableview(_ tableview: UITableView, notesTableCell indexPath : IndexPath) -> UITableViewCell {
        let cell = tblVwNotes.deque(NotesTableCell.self, at: indexPath)
        cell.vwBg.addRoundedViewCorners(width: 10, colorBorder: UIColor.clear)
        cell.vwBg.addDropShadow()
        cell.vwHeaderBg.roundViewTopEdges(radius: 10)
        cell.noteLbl.text = notesArr[indexPath.row]["note"] ?? ""
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteNote(_:)), for: .touchUpInside)
        cell.editBtn.addTarget(self, action: #selector(editNote(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    @objc func deleteNote(_ sender : UIButton){
        guard
            let myId = UserInfo.curentUser?.id,
            let noteKey = notesArr[sender.tag]["key"]
            else {
                print("data nil")
                return
        }
        ref = Database.database().reference()
        ref.child("favUserNotes").child(myId).child(noteKey).removeValue()
        getFavUserNotes()
    }
    
    @objc func editNote(_ sender : UIButton){
        let vcAddNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesVC") as! AddNotesVC
        vcAddNotesVC.girlId = girlId
        vcAddNotesVC.editNote = true
        vcAddNotesVC.prevData = notesArr[sender.tag]
        vcAddNotesVC.delegate = self
        vcAddNotesVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vcAddNotesVC, animated: true)
    }
    
}
extension NotesListVC : reloadNoteDelegate {
    func reloadNotes() {
        getFavUserNotes()
    }
}
