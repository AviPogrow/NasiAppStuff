//
//  FullTimeYeshivaViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
class FullTimeYeshivaViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    // ----------------------------------
    // MARK: - IB-OUTLET(S)
    //
    @IBOutlet weak var segmentCntrl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    fileprivate let singleCellIdentifier = "SingleCellID"
    
    var arrGirlsList = [NasiGirlsList]()
    
    var arrOneToFiveSingleGirls = [NasiGirlsList]()
    var arrFiveYearsSingleGirls = [NasiGirlsList]()
    var arrFiveToSevenSingleGirls = [NasiGirlsList]()
    var arrFilterList = [NasiGirlsList]()
    var arrTempFilterList = [NasiGirlsList]()
    var arrOnetoThreeSingleGirls = [NasiGirlsList]()
    var arrThreeToFiveSingleGirls = [NasiGirlsList]()
    
    var fiveToSevenSingleGirls = [NasiGirlsList]()
    var sevenPlusSingleGirls = [NasiGirlsList]()
    var arrSectionSearch = [NasiGirlsList]()
    
    var aryFirstSegmentFilter = [[NasiGirlsList]]() //discuss
    var searchActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        self.setUpSegmentControlApperance()
        navigationItem.title = "Full Time Yeshiva"
        setBackBtn()
        arrGirlsList = self.arrGirlsList.sorted(by: { Int($0.dateOfBirth ?? 0) < Int($1.dateOfBirth ?? 0) })
        
        arrGirlsList = self.arrGirlsList.filter { (girlList) -> Bool in
            return girlList.category == Constant.CategoryTypeName.kPredicateString1  || girlList.category == Constant.CategoryTypeName.kPredicateString2 || girlList.category == Constant.CategoryTypeName.kPredicateString3
        }
        
        arrOneToFiveSingleGirls = self.arrGirlsList.filter { (girlList) -> Bool in
            return girlList.yearsOfLearning == "1-3"  || girlList.yearsOfLearning == "1-3:3-5" || girlList.yearsOfLearning == "1-3:3-5:5" || girlList.yearsOfLearning == "3-5" ||
                girlList.yearsOfLearning == "1-3:3-5" ||
                girlList.yearsOfLearning == "1-3:3-5:5" ||
                girlList.yearsOfLearning == "3-5:5" ||
                girlList.yearsOfLearning == "3-5:5:5-7"
        }
        
        /*Segment Section Filter*/
        arrOnetoThreeSingleGirls = arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "1-3" || singleGirl.yearsOfLearning == "1-3:3-5" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5"
        }
        
        arrThreeToFiveSingleGirls = arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "3-5" ||
                singleGirl.yearsOfLearning == "1-3:3-5" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7"
        }
        
        arrFiveYearsSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.yearsOfLearning == "5" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7" ||
                singleGirl.yearsOfLearning == "5:5-7:7+"
        }
        
        arrFiveToSevenSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.yearsOfLearning == "5-7" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7" ||
                singleGirl.yearsOfLearning == "5:5-7" ||
                singleGirl.yearsOfLearning == "5-7:7+" ||
                singleGirl.yearsOfLearning == "7+" ||
                singleGirl.yearsOfLearning == "5:5-7:7+" ||
                singleGirl.yearsOfLearning == "5-7:7+"
        }
        
        /*Third Segment Section Filter*/
        fiveToSevenSingleGirls = self.arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "5-7" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7" ||
                singleGirl.yearsOfLearning == "5:5-7" ||
                singleGirl.yearsOfLearning == "5-7:7+"
        }
        sevenPlusSingleGirls = self.arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "7+" ||
                singleGirl.yearsOfLearning == "5:5-7:7+" ||
                singleGirl.yearsOfLearning == "5-7:7+"
            
        }
        
        
        //      aryFirstSegmentFilter = [fiveToSevenSingleGirls,sevenPlusSingleGirls]
        self.segmentCntrlTapped(segmentCntrl!)
        
    }
    
    func setUpSegmentControlApperance() {
        segmentCntrl.selectedSegmentTintColor = Constant.AppColor.colorAppTheme
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: Constant.AppFontHelper.defaultSemiboldFontWithSize(size: 16)]
        segmentCntrl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        
        let titleTextAttributesDefault = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                          NSAttributedString.Key.font: Constant.AppFontHelper.defaultRegularFontWithSize(size: 16)]
        segmentCntrl.setTitleTextAttributes(titleTextAttributesDefault, for:.normal)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
    }
    
    @IBAction func segmentCntrlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            arrFilterList = arrOneToFiveSingleGirls
            print("here is segmrnt first", arrFilterList.count)
        } else if sender.selectedSegmentIndex == 1 {
            arrFilterList = arrFiveYearsSingleGirls
        } else {
            arrFilterList = arrFiveToSevenSingleGirls
        }
        self.tableView.reloadData()
    }
    
    
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentCntrl.selectedSegmentIndex == 0 || segmentCntrl.selectedSegmentIndex == 2 {
            return 2
        } else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentCntrl.selectedSegmentIndex == 0 {
            if section == 0 {
                return "1 - 3 Years of Learning"
            } else {
                return "3 - 5 Years of Learning"
            }
        } else if segmentCntrl.selectedSegmentIndex == 1 {
            return "5  Years of Learning" // Not Used
        } else {
            if section == 0 {
                return "5 - 7 Years of Learning"
            } else {
                return "7+ Years Of Learning"
            }
        }
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentCntrl.selectedSegmentIndex == 0 {
            if section == 0 {
                arrFilterList = arrOnetoThreeSingleGirls
                return arrFilterList.count
            } else if section == 1 {
                arrFilterList = arrThreeToFiveSingleGirls
                return arrFilterList.count
            }
        } else if segmentCntrl.selectedSegmentIndex == 2 {
            if section == 0 {
                arrFilterList = fiveToSevenSingleGirls
                return arrFilterList.count
            } else {
                arrFilterList = sevenPlusSingleGirls
                return arrFilterList.count
            }
        }
        return arrFilterList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: singleCellIdentifier, for: indexPath) as! SingleTableViewCell
        
        var model: NasiGirlsList!
        model = arrFilterList[indexPath.row]
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
        
        /*
         if let imgUrl = model.imageDownloadURLString{
         let url = URL(string: imgUrl)
         cell.profileImageView.kf.indicatorType = .activity
         cell.profileImageView.kf.setImage(with: url)
         }
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isDecelerating {
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*
         Analytics.logEvent("view_search_results", parameters: [
         "search_term": self.searchbar.text!,
         "selected_result_number" : indexPath.row,
         ])*/
        
        if segue.identifier == "ShowSingleDetail" {
            guard let tableViewCell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: tableViewCell),
                let controller = segue.destination as? SingleDetailViewController else {
                    return
            }
            
            var currentSingle: NasiGirlsList!
            currentSingle = arrFilterList[indexPath.row]
            controller.selectedSingle = currentSingle
            
            Analytics.logEvent("view_ShowSingleDetail", parameters: [
                "selected_item_name": currentSingle.firstNameOfGirl ?? "",
                "selected_item_number": indexPath.row,
                "screen_name": "fulltimeyeshiva"
            ])
            
        }
    }
}

// MARK: - SEARCHBAR DELEGATE(S)
extension FullTimeYeshivaViewController:UISearchBarDelegate {
    
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
        if segmentCntrl.selectedSegmentIndex == 0 {
            Analytics.logEvent("fullTimeYeshiva_screen_segmentControl_act", parameters: [
                "item_name": "1-5 Years of Learning",
            ])
            arrTempFilterList = arrOneToFiveSingleGirls
        } else if segmentCntrl.selectedSegmentIndex == 1 {
            Analytics.logEvent("fullTimeYeshiva_screen_segmentControl_act", parameters: [
                "item_name": "5 Years of Learning",
            ])
            arrTempFilterList = arrFiveYearsSingleGirls
        } else {
            Analytics.logEvent("fullTimeYeshiva_screen_segmentControl_act", parameters: [
                "item_name": "5+ Years Of Learning",
            ])
            arrTempFilterList = arrFiveToSevenSingleGirls
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
