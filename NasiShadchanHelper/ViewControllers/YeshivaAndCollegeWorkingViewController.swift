//
//  YeshivaAndCollegeWorkingViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/1/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase

class YeshivaAndCollegeWorkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // ----------------------------------
    // MARK: - IB-OUTLET(S)
    //
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrGirlsList = [NasiGirlsList]()
    var arrProTracKSingleGirls = [NasiGirlsList]()
    var arrNoProTrackSingleGirls = [NasiGirlsList]()
    var arrFilterList = [NasiGirlsList]()
    var arrTempFilterList = [NasiGirlsList]()
    let cellID = "HTCollegeTableCell"
    
    var selectedCategory = "YeshivaandCollege/Working"
    
    let str1 = "Doesnotneedprofessionaltrack"
    let str2 = "N/A"
    let str3 = "Needsprofessionaltrack"
    var searchActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notifRefreshNasiList(notificationReceived:)), name: Constant.EventNotifications.notifRefreshNasiList, object: nil)
        
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        let point = CGPoint(x: 0, y:(self.navigationController?.navigationBar.frame.size.height)!)
        self.tableView.setContentOffset(point, animated: true)
        
        tableView.dataSource = self
        tableView.delegate = self
        setBackBtn()
        
        if Variables.sharedVariables.arrayForResearchList.count > 0 {
            arrGirlsList = self.arrGirlsList.filter { (girlList) -> Bool in
                return !Variables.sharedVariables.arrayForResearchList.contains(girlList.currentGirlUID ?? "")
            }
        }
        
        self.arrGirlsList = self.arrGirlsList.sorted(by: { Int($0.dateOfBirth ?? 0) < Int($1.dateOfBirth ?? 0) })
        
        self.arrGirlsList = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.category == Constant.CategoryTypeName.kPredicateString2 || singleGirl.category == Constant.CategoryTypeName.kPredicateString3 || singleGirl.category == Constant.CategoryTypeName.kCategoryString1
        }
        
        self.arrNoProTrackSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.professionalTrack == "does not need professional track" || singleGirl.professionalTrack == "Does not need professional track"
        }
        
        self.arrProTracKSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.professionalTrack == "Needs professional track"
        }
        
        
        arrFilterList = arrProTracKSingleGirls
        tableView.reloadData()
        
        let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: segmentColor]
        segmentControl.selectedSegmentTintColor = segmentColor
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .highlighted)
    }
    
    // MARK:- Selectors
    @objc func notifRefreshNasiList(notificationReceived : Notification) {
        print("here is selected segment control", segmentControl.selectedSegmentIndex)
        if let object = notificationReceived.object as? [String: Any] {
            if let currentGirlId = object["updateCurrentGirlId"] as? String {
                if segmentControl.selectedSegmentIndex == 0 {
                    arrProTracKSingleGirls = self.arrProTracKSingleGirls.filter { (girlList) -> Bool in
                        return girlList.currentGirlUID != currentGirlId
                    }
                    
                    arrFilterList = arrProTracKSingleGirls
                    
                } else if segmentControl.selectedSegmentIndex == 1 {
                    arrNoProTrackSingleGirls = self.arrNoProTrackSingleGirls.filter { (girlList) -> Bool in
                        return girlList.currentGirlUID != currentGirlId
                    }
                    arrFilterList = arrNoProTrackSingleGirls
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            arrFilterList = arrProTracKSingleGirls
            Analytics.logEvent("YeshivaAndCollegeWorking_screen_segmentControl_act", parameters: [
                "item_name": "Need Pro Track",
            ])
        } else if segmentControl.selectedSegmentIndex == 1 {
            arrFilterList = arrNoProTrackSingleGirls
            Analytics.logEvent("YeshivaAndCollegeWorking_screen_segmentControl_act", parameters: [
                "item_name": "Does Not Need Pro Track",
            ])
            
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as!  HTCollegeTableViewCell
        
        var currentSingle: NasiGirlsList!
        currentSingle = arrFilterList[indexPath.row]
        
        if (currentSingle.imageDownloadURLString ?? "").isEmpty {
            cell.profileImageView.image = UIImage.init(named: "placeholder")
        } else {
            cell.profileImageView.loadImageFromUrl(strUrl: String(format: "%@",currentSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        
        // 1st Label - Age
        cell.nameLabel.text = (currentSingle.firstNameOfGirl ?? "") + " " + (currentSingle.lastNameOfGirl ?? "")
        
        // 2nd Label - Age/Height
        let heightInFt = currentSingle.heightInFeet ?? ""
        let heightInInches = currentSingle.heightInInches ?? ""
        
        let height = "\(heightInFt)\'" + "\(heightInInches)\""
        
        // currentSingle.dateOfBirth
        cell.ageHeightLabel.text = "\(currentSingle.dateOfBirth ?? 0.0)" + "-" + height // 2nd Age - Height
        
        // 3rd Label
        cell.cityLabel.textColor = UIColor.black
        cell.cityLabel.text =  currentSingle.cityOfResidence
        
        // 4th Label
        cell.categoryLabel.textColor = .lightGray
        cell.categoryLabel.text = currentSingle.category ?? ""     
        
        // 5th Label is seminary
        cell.seminaryLabel.text = currentSingle.seminaryName ?? ""
        
        
        // 6th label - Pro Track
        let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        
        if (currentSingle.professionalTrack == "does not need professional track") || (currentSingle.professionalTrack == "Does not need professional track") {
            
            cell.professionalTrackLabel.textColor = segmentColor
            cell.professionalTrackLabel.text = "Doesn't Need Pro Track"
        } else {
            cell.professionalTrackLabel.textColor = segmentColor
            cell.professionalTrackLabel.text = "Needs Pro Track"
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isDecelerating {
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetails" {
            let controller = segue.destination as! ShadchanListDetailViewController
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                var currentSingle: NasiGirlsList!
                currentSingle = arrFilterList[indexPath.row]
                /*
                 if segmentControl.selectedSegmentIndex == 0 {
                 currentSingle = arrProTracKSingleGirls[indexPath.row]
                 } else {
                 currentSingle = arrNoProTrackSingleGirls[indexPath.row]
                 }*/
                controller.selectedSingle = currentSingle
                
                Analytics.logEvent("view_ShowSingleDetail", parameters: [
                    "selected_item_name": currentSingle.firstNameOfGirl ?? "",
                    "selected_item_number": indexPath.row,
                    "screen_name": "YeshivaAndCollege"
                ])
                
            }
        }
    }
    
}

// MARK: - SEARCHBAR DELEGATE(S)
extension YeshivaAndCollegeWorkingViewController:UISearchBarDelegate {
    
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
        if segmentControl.selectedSegmentIndex == 0 {
            arrTempFilterList = arrProTracKSingleGirls
        }  else {
            arrTempFilterList = arrNoProTrackSingleGirls
        }
        
        let searchFinalText = searchText.uppercased()
        if searchFinalText.count != 0 {
            arrFilterList.removeAll()
            if arrTempFilterList.count != 0 {
                for a in 0...arrTempFilterList.count-1{
                    if ((arrTempFilterList[a].lastNameOfGirl?.uppercased())?.contains(searchFinalText))!{
                        arrFilterList.append(arrTempFilterList[a])
                    }
                }
                self.displayFilteredEmotionsInTable()
            } else {
                arrFilterList.removeAll()
                arrFilterList = arrTempFilterList
                self.displayFilteredEmotionsInTable()
            }
        } else {
            arrFilterList.removeAll()
            arrFilterList = arrTempFilterList
            self.displayFilteredEmotionsInTable()
        }
    }
    
    func displayFilteredEmotionsInTable () {
        if arrFilterList.count > 0 {
        } else {
            print("there is no data")
        }
        self.tableView.reloadData()
        
    }
}
