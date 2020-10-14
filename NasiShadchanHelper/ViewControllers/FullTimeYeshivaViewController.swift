//
//  FullTimeYeshivaViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Kingfisher

class FullTimeYeshivaViewController: UITableViewController {
    
    
    // MARK: - Properties
    fileprivate let singleCellIdentifier = "SingleCellID"
    
    var arrGirlsList = [NasiGirlsList]()
    
    var arrOnetothreeSingleGirls = [NasiGirlsList]()
    var arrThreeToFiveSingleGirls = [NasiGirlsList]()
    var arrFiveYearsSingleGirls = [NasiGirlsList]()
    var arrFiveToSevenSingleGirls = [NasiGirlsList]()
    var arrSevenPlusSingleGirls = [NasiGirlsList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Full Time Yeshiva"
        
        arrGirlsList = self.arrGirlsList.sorted(by: { Int($0.dateOfBirth ?? 0) < Int($1.dateOfBirth ?? 0) })
        
        arrGirlsList = self.arrGirlsList.filter { (girlList) -> Bool in
            return girlList.category == Constant.CategoryTypeName.kPredicateString1  || girlList.category == Constant.CategoryTypeName.kPredicateString2 || girlList.category == Constant.CategoryTypeName.kPredicateString3
        }
        
        arrOnetothreeSingleGirls = self.arrGirlsList.filter { (girlList) -> Bool in
            return girlList.yearsOfLearning == "1-3"  || girlList.yearsOfLearning == "1-3:3-5" || girlList.yearsOfLearning == "1-3:3-5:5"
        }
        
        arrThreeToFiveSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.yearsOfLearning == "3-5" ||
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
                singleGirl.yearsOfLearning == "5-7:7+"
        }
        
        arrSevenPlusSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.yearsOfLearning == "7+" ||
                singleGirl.yearsOfLearning == "5:5-7:7+" ||
                singleGirl.yearsOfLearning == "5-7:7+"
        }
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "1 - 3 Years of Learning"
        } else if section == 1 {
            return "3 - 5 Years of Learning"
        } else if section == 2 {
            return "5  Years of Learning"
        } else if section == 3 {
            return "5 - 7 Years of Learning"
        } else {
            return "7+ Years Of Learning"
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrOnetothreeSingleGirls.count
        } else if section == 1 {
            return arrThreeToFiveSingleGirls.count
        } else if section == 2 {
            return arrFiveYearsSingleGirls.count
        } else if section == 3  {
            return arrFiveToSevenSingleGirls.count
        } else {
            return arrSevenPlusSingleGirls.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: singleCellIdentifier, for: indexPath) as! SingleTableViewCell
        
        var model: NasiGirlsList!
        if indexPath.section == 0 {
            model = arrOnetothreeSingleGirls[indexPath.row]
        } else if indexPath.section == 1 {
            model = arrThreeToFiveSingleGirls[indexPath.row]
        } else if indexPath.section == 2 {
            model = arrFiveYearsSingleGirls[indexPath.row]
        } else if indexPath.section == 3 {
            model = arrFiveToSevenSingleGirls[indexPath.row]
        } else {
            model = arrSevenPlusSingleGirls[indexPath.row]
        }
        
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
            cell.profileImageView.loadImageFromUrl(strUrl: String(format: "%@",model.imageDownloadURLString!), imgPlaceHolder: "placeholder")
            print("this is not empty....", model.imageDownloadURLString ?? "")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "ShowSingleDetail" {
            guard let tableViewCell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: tableViewCell),
                let controller = segue.destination as? SingleDetailViewController else {
                    return
            }
            
            var currentSingle: NasiGirlsList!
            if indexPath.section == 0 {
                currentSingle = arrOnetothreeSingleGirls[indexPath.row]
            } else if indexPath.section == 1 {
                currentSingle = arrThreeToFiveSingleGirls[indexPath.row]
            } else if indexPath.section == 2 {
                currentSingle = arrFiveYearsSingleGirls[indexPath.row]
            } else if indexPath.section == 3 {
                currentSingle = arrFiveToSevenSingleGirls[indexPath.row]
            } else {
                currentSingle = arrSevenPlusSingleGirls[indexPath.row]
            }
            controller.selectedSingle = currentSingle
        }
    }
}
