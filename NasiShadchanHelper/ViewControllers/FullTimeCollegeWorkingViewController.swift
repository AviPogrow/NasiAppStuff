//
//  FullTimeCollegeWorkingViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/30/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class FullTimeCollegeWorkingViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    let cellIdentifier = "FullTimeCollegeCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    var arrGirlsList = [NasiGirlsList]()
    var arrNeedsKoveaSingleGirls = [NasiGirlsList]()
    var arrDoesNotNeedKoveaSingleSirls = [NasiGirlsList]()
    
    let dontNeedString = "Donotneedkoveahittim"
    let needString = "Needkoveahittim"
    let categoryString = "FullTimeCollege/Working"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setBackBtn()
        arrGirlsList = self.arrGirlsList.sorted(by: { Int($0.dateOfBirth ?? 0) < Int($1.dateOfBirth ?? 0) })
        
        arrGirlsList = self.arrGirlsList.filter { (girlList) -> Bool in
            return girlList.category == Constant.CategoryTypeName.kCategoryString0  || girlList.category == Constant.CategoryTypeName.kCategoryString1 || girlList.category == Constant.CategoryTypeName.kPredicateString2
        }
        
        arrNeedsKoveaSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.koveahIttim == "Need koveah ittim"
        }
        
        arrDoesNotNeedKoveaSingleSirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.koveahIttim == "do not need koveah ittim"
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
    
     // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("the selectedIndex is \(selectedIndex) and title is \(String(describing: sender.titleForSegment(at: selectedIndex)))")
        tableView.reloadData()
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentControl.selectedSegmentIndex == 0 {
            return arrDoesNotNeedKoveaSingleSirls.count
        } else {
            return arrNeedsKoveaSingleGirls.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!
        FTCollegeTableViewCell
        
        
        
        let segmentColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        
        var currentGirl: NasiGirlsList!
        
        if segmentControl.selectedSegmentIndex == 0 {
            
            currentGirl = arrDoesNotNeedKoveaSingleSirls[indexPath.row]
        } else {
            currentGirl = arrNeedsKoveaSingleGirls[indexPath.row]
        }
        
        
        cell.nameLabel.text = (currentGirl.firstNameOfGirl ?? "") + " " + (currentGirl.lastNameOfGirl ?? "")
        
        let heightInFt = currentGirl.heightInFeet ?? ""
        let heightInInches = currentGirl.heightInInches ?? ""
        
        let height = "\(heightInFt)\'" + "\(heightInInches)\""
        
        cell.ageHeightLabel.text = "\(currentGirl.dateOfBirth ?? 0.0)" + "-" + height // 2nd Age - Height
        
        // 3rd label - city
        cell.cityLabel.text = currentGirl.cityOfResidence ?? ""
        
        // 4th Label is category codes Label
        cell.categoryLabel.text = currentGirl.category 
        
        // 5th Label -  seminary
        cell.seminaryLabel.text = currentGirl.seminaryName ?? ""
        //cell.proPlanLabel.text = currentGirl.city
        
        // 6th Label - Pro Track
        // 6th Label Kovea Ittim
        if currentGirl.koveahIttim == "do not need koveah ittim" {
            cell.koveahIttimLabel.backgroundColor = UIColor.white
            cell.koveahIttimLabel.textColor = segmentColor
            cell.koveahIttimLabel.text = "Doesn't need kovea ittim"
        } else {
            
            cell.koveahIttimLabel.textColor = segmentColor
            cell.koveahIttimLabel.backgroundColor = UIColor.white
            cell.koveahIttimLabel.text = "Must be kovea ittimm"
        }
        
        if (currentGirl.imageDownloadURLString ?? "").isEmpty {
            cell.profileImageView.image = UIImage.init(named: "placeholder")
        } else {
            cell.profileImageView.loadImageFromUrl(strUrl: String(format: "%@",currentGirl.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        
        
        return cell
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleDetails" {
            
            let controller = segue.destination as! SingleDetailViewController
            if let indexPath = tableView.indexPath(for: sender
                as! UITableViewCell) {
                
                var currentGirl: NasiGirlsList!
                
                if segmentControl.selectedSegmentIndex == 0 {
                    
                    currentGirl = arrDoesNotNeedKoveaSingleSirls[indexPath.row]
                } else {
                    currentGirl = arrNeedsKoveaSingleGirls[indexPath.row]
                }
                controller.selectedSingle = currentGirl
            }
        }
    }
}
