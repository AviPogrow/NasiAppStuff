//
//  FavoritesViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/3/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // ----------------------------------
    // MARK: - IB-OUTLET(S)
    //
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwNoDataFound: UIView!
    @IBOutlet weak var segmentCntrl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    struct TableView {
        struct CellIdentifiers {
            static let savedSingleCell = "SavedSingleCell"
        }
    }
    
    // MARK: - Properties
    fileprivate let singleCellIdentifier = "SingleCellID"

    var favChildArr = [[String : String]]()
    var sentSegmentChildArr = [[String : String]]()
    var arrSentSegmentFavGirlsList = [NasiGirlsList]()
    var aryChildKey = [String]()


    var arrFavGirlsList = [NasiGirlsList]()
    var arrMainGirlsList = [NasiGirlsList]()
    var arrTempFilterList = [NasiGirlsList]()
    var searchActive:Bool = false
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSegmentControlApperance()
        navigationItem.title = "My Saved Nasi Singles"
        
        NotificationCenter.default.addObserver(self, selector: #selector(favouriteRemovedByUser(notificationReceived:)), name: Constant.EventNotifications.notifRemoveFromFav, object: nil)
        
        let cellNib = UINib(nibName: TableView.CellIdentifiers.savedSingleCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.savedSingleCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        self.vwNoDataFound.isHidden = true
        self.updateFav()
        self.getResearchList()
        self.getSentResumeList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK:- Selectors
    @objc func favouriteRemovedByUser(notificationReceived : Notification) {
      //  self.getResearchList()
          updateFav()
    }
    
    func setUpSegmentControlApperance() {
        segmentCntrl.selectedSegmentTintColor = Constant.AppColor.colorAppTheme
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: Constant.AppFontHelper.defaultRegularFontWithSize(size: 14)]
        segmentCntrl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        
        let titleTextAttributesDefault = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                          NSAttributedString.Key.font: Constant.AppFontHelper.defaultRegularFontWithSize(size: 14)]
        segmentCntrl.setTitleTextAttributes(titleTextAttributesDefault, for:.normal)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
    }
    
    @IBAction func segmentCntrlTapped(_ sender: UISegmentedControl) {
        self.reloadSegmentCntrl(selectedIndex: sender.selectedSegmentIndex)
    }
    
    func reloadSegmentCntrl(selectedIndex:Int) {
        if selectedIndex == 0 {
            Analytics.logEvent("favourite_screen_segmentControl_act", parameters: [
                "item_name": "Full Time Yeshiva",
            ])
            
            arrFavGirlsList = self.arrMainGirlsList
            
        } else if selectedIndex == 1 {
            Analytics.logEvent("favourite_screen_segmentControl_act", parameters: [
                "item_name": "Full Time College/Working",
            ])
            
            arrFavGirlsList = self.arrSentSegmentFavGirlsList
        }
        
        arrTempFilterList = arrFavGirlsList
        if arrFavGirlsList.count > 0 {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.vwNoDataFound.isHidden = true
            
        } else {
            self.tableView.isHidden = true
            self.vwNoDataFound.isHidden = false
        }
        
    }
    
    func getResearchList() {
        // self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        print("here is id", myId) //"myFav"
        ref.child("research").child(myId).observe(.childAdded) { (snapShots) in
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
                    // arrFavGirlsList.removeAll()
                    self.favChildArr.append(dict)
                    self.filterFavData()
                } else {
                    print("not a valid data")
                }
            }
        }
        
        self.filterFavData()
    }
    
    func getSentResumeList() {
        // self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        print("here is id", myId) //"myFav"
        ref.child("sentsegment").child(myId).observe(.childAdded) { (snapShots) in
            self.view.hideLoadingIndicator()
            self.sentSegmentChildArr.removeAll()
            let snap = snapShots.value as? [String : Any]
            print(snap)
            if (snapShots.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    print(dict)
                    // arrFavGirlsList.removeAll()
                    self.sentSegmentChildArr.append(dict)
                    self.filterSentResumeData()
                } else {
                    print("not a valid data")
                }
            }
        }
        
        self.filterSentResumeData()
    }

    func filterSentResumeData() {
        if sentSegmentChildArr.count > 0 {
            print("here is fav child", sentSegmentChildArr)
            print("here is fav child count", sentSegmentChildArr.count)
            for (index,list) in Variables.sharedVariables.arrList.enumerated() {
                let currentId = list.currentGirlUID
                for (innerIndex,list) in sentSegmentChildArr.enumerated() {
                    let userId = list["userId"]
                    let childKey = list["child_key"]
                    print("here is user id", userId ?? "")
                    print("here is child key", childKey ?? "")
                    if currentId == userId {
                        print("append")
                        arrSentSegmentFavGirlsList.append(Variables.sharedVariables.arrList[index])
                    }
                }
            }
            
           // self.reloadSegmentCntrl(selectedIndex: 1)
            
        } else {
            self.tableView.isHidden = true
            self.vwNoDataFound.isHidden = false
            print("here is no fav child")
        }
    }

    
    func updateFav(){
        //  self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        ref.child("research").child(myId).observe(.childRemoved) { (snapShots) in
            self.view.hideLoadingIndicator()
            //            self.favChildArr.removeAll()
            let snap = snapShots.value as? [String : Any]
            print(snap)
            if (snapShots.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    print(dict)
                    if self.favChildArr.contains(dict) {
                        guard let idx = self.favChildArr.firstIndex(of: dict) else{
                            print("nnn--")
                            return
                        }
                        self.favChildArr.remove(at: idx)
                    }
                    self.arrFavGirlsList.removeAll()
                    self.arrMainGirlsList.removeAll()
                    // self.favChildArr.append(dict)
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
            for (index,list) in Variables.sharedVariables.arrList.enumerated() {
                let currentId = list.currentGirlUID
                for (innerIndex,list) in favChildArr.enumerated() {
                    let userId = list["userId"]
                    let childKey = list["child_key"]
                    print("here is user id", userId ?? "")
                    print("here is child key", childKey ?? "")
                    if currentId == userId {
                        print("append")
                        arrFavGirlsList.append(Variables.sharedVariables.arrList[index])
                        aryChildKey.append(childKey!)
                    }
                }
            }
            
            arrMainGirlsList = arrFavGirlsList
            print("here is fav",arrFavGirlsList.count)
            self.reloadSegmentCntrl(selectedIndex: 0)
        } else {
            self.tableView.isHidden = true
            self.vwNoDataFound.isHidden = false
            print("here is no fav child")
        }
    }
    
    // MARK: - Table View Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavGirlsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: singleCellIdentifier, for: indexPath) as! SingleTableViewCell
        
        var model: NasiGirlsList!
        model = arrFavGirlsList[indexPath.row]
        print("here is dob", model.dateOfBirth ?? "")
        
        cell.nameLabel?.text =  "\(model.firstNameOfGirl ?? "")" + " "  + "\(model.lastNameOfGirl ?? "")" //top 1 name
        
        let heightInFt = model.heightInFeet ?? ""
        let heightInInches = model.heightInInches ?? ""
        
        let height = "\(heightInFt)\'" + "\(heightInInches)\""
        
        cell.ageHeightLabel.text = "\(model.dateOfBirth ?? 0.0)" + "-" + height // 2nd Age - Height
        
        cell.cityLabel.text = "\(model.cityOfResidence ?? "")"  // 3rd Label - City
        cell.categoryLabel.textColor = .lightGray
        cell.categoryLabel.text = "\(model.category ?? "") - " + (model.yearsOfLearning ?? "") // 4th Label - Categories
        cell.SeminaryLabel.text = model.seminaryName ?? ""  //5th Label - Seminary
        cell.parnassahPlanLabel.text = "\(model.plan ?? "")"  // 6th Label - Plan
        
        
        if (model.imageDownloadURLString ?? "").isEmpty {
            print("this is empty....", model.imageDownloadURLString ?? "")
            cell.profileImageView?.image = UIImage.init(named: "placeholder")
        } else {
            //  img.kf.indicatorType = .activity
            cell.profileImageView.loadImageFromUrl(strUrl: String(format: "%@",model.imageDownloadURLString!), imgPlaceHolder: "placeholder")
            print("this is not empty....", model.imageDownloadURLString ?? "")
        }
                
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
        
        /*
         let vcFavDetail = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteDetailVC") as! FavoriteDetailVC
         self.navigationController?.pushViewController(vcFavDetail, animated: true)
         */
        /*
         let vcSingleDetail = self.storyboard?.instantiateViewController(withIdentifier: "SingleDetailViewController") as! SingleDetailViewController
         vcSingleDetail.selectedSingle = arrFavGirlsList[indexPath.row]
         vcSingleDetail.isFromFav = true
         vcSingleDetail.delegate = self
         self.navigationController?.pushViewController(vcSingleDetail, animated: true)
         */
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isDecelerating {
            searchBar.resignFirstResponder()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destination as! ShadchanListDetailViewController
            let indexPath = sender as! IndexPath
            detailViewController.selectedSingle = arrFavGirlsList[indexPath.row]
            
            Analytics.logEvent("view_favouriteDetail", parameters: [
                "selected_item_name": arrFavGirlsList[indexPath.row].firstNameOfGirl ?? "",
                "selected_item_number": indexPath.row,
                "screen_name": "FavoritesViewController"
            ])
            
        }
    }
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
      }

    // this method handles row deletion
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
            let alertControler = UIAlertController.init(title:"", message: Constant.ValidationMessages.msgConfirmationToDelete, preferredStyle:.alert)
            alertControler.addAction(UIAlertAction.init(title:"Yes", style:.default, handler: { (action) in
                print("yes")
                if self.arrFavGirlsList.count > 0 {
                    self.arrFavGirlsList.remove(at: indexPath.row)
                    self.swipeDeleteRemoveFromList(self.aryChildKey[indexPath.row])
                    self.tableView.reloadData()
                }
            }))
            alertControler.addAction(UIAlertAction.init(title:"No", style:.destructive, handler: { (action) in
                 print("no")
            }))
            self.present(alertControler,animated:true, completion:nil)
          }
      }
    
    func swipeDeleteRemoveFromList(_ childKey:String) {
        ref = Database.database().reference()
        let myId = UserInfo.curentUser?.id
        ref.child("research").child(myId!).child(childKey).removeValue { (error, dbRef) in
            self.view.hideLoadingIndicator()
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(dbRef.key)
            }
        }
    }
}

extension FavoritesViewController : reloadDataDelegate{
    func reloadData(isTrue: Bool) {
        if isTrue{
            self.navigationController?.popViewController(animated: true)
            updateFav()
        }
    }
    
}
// MARK: - SEARCHBAR DELEGATE(S)
extension FavoritesViewController:UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadSegmentCntrl(selectedIndex: segmentCntrl.selectedSegmentIndex)
        let searchFinalText = searchText.uppercased()
        if searchFinalText.count != 0 {
            arrFavGirlsList.removeAll()
            if arrTempFilterList.count != 0 {
                for a in 0...arrTempFilterList.count-1{
                    if ((arrTempFilterList[a].lastNameOfGirl?.uppercased())?.contains(searchFinalText))!{
                        arrFavGirlsList.append(arrTempFilterList[a])
                    }
                }
                self.displayFilteredEmotionsInTable()
            } else {
                arrFavGirlsList.removeAll()
                arrFavGirlsList = arrTempFilterList
                self.displayFilteredEmotionsInTable()
            }
        } else {
            arrFavGirlsList.removeAll()
            arrFavGirlsList = arrTempFilterList
            self.displayFilteredEmotionsInTable()
        }
    }
    
    func displayFilteredEmotionsInTable () {
        if arrFavGirlsList.count > 0 {
        } else {
            print("there is no data")
        }
        self.tableView.reloadData()
    }
}
