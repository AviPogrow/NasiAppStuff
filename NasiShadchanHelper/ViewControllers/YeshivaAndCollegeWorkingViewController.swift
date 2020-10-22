//
//  YeshivaAndCollegeWorkingViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/1/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class YeshivaAndCollegeWorkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var arrGirlsList = [NasiGirlsList]()
    var arrProTracKSingleGirls = [NasiGirlsList]()
    var arrNoProTrackSingleGirls = [NasiGirlsList]()
    
    let cellID = "HTCollegeTableCell"
    
    var selectedCategory = "YeshivaandCollege/Working"
    
    let str1 = "Doesnotneedprofessionaltrack"
    let str2 = "N/A"
    let str3 = "Needsprofessionaltrack"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setBackBtn()
        arrGirlsList = self.arrGirlsList.sorted(by: { Int($0.dateOfBirth ?? 0) < Int($1.dateOfBirth ?? 0) })
        
        self.arrGirlsList = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.category == Constant.CategoryTypeName.kPredicateString2 || singleGirl.category == Constant.CategoryTypeName.kPredicateString3 || singleGirl.category == Constant.CategoryTypeName.kCategoryString1
        }
        
        arrNoProTrackSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.professionalTrack == "does not need professional track" || singleGirl.professionalTrack == "Does not need professional track"
        }
        arrProTracKSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.professionalTrack == "Needs professional track"
        }
        
        tableView.reloadData()
        
        let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: segmentColor]
        segmentControl.selectedSegmentTintColor = segmentColor
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .highlighted)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentControl.selectedSegmentIndex == 0 {
            return arrProTracKSingleGirls.count
        }
        return arrNoProTrackSingleGirls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as!  HTCollegeTableViewCell
        
        var currentSingle: NasiGirlsList!
        if segmentControl.selectedSegmentIndex == 0 {
            currentSingle = arrProTracKSingleGirls[indexPath.row]
        } else {
            currentSingle = arrNoProTrackSingleGirls[indexPath.row]
        }
        
        
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
    
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetails" {
            let controller = segue.destination as! SingleDetailViewController
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                
                var currentSingle: NasiGirlsList!
                if segmentControl.selectedSegmentIndex == 0 {
                    currentSingle = arrProTracKSingleGirls[indexPath.row]
                } else {
                    currentSingle = arrNoProTrackSingleGirls[indexPath.row]
                }
                controller.selectedSingle = currentSingle
            }
        }
    }
    
}
