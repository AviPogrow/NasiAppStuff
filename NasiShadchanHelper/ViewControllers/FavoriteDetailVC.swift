//
//  FavoriteDetailVC.swift
//  NasiShadchanHelper
//
//  Created by apple on 23/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class FavoriteDetailVC: UIViewController {
    
    // MARK: - IB-OUTLET(S)
    @IBOutlet weak private var tblVw: UITableView!
    var sectionTitles = ["Girl's name", "Girl's Details", "Shidduch details","To redd a shidduch","To discuss a shidduch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
    }
    
    func registerNib() {
        tblVw.register(GirlsDetailTableCell.self)
    }
}

// MARK: - Table View Delegate DataSource
extension FavoriteDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionHeaderVw: UIView?
        sectionHeaderVw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30.0))
        let lblHeader = UILabel(frame: CGRect(x: sectionHeaderVw?.frame.origin.x ?? 0.0, y: (sectionHeaderVw?.frame.origin.y ?? 0.0), width: sectionHeaderVw?.frame.size.width ?? 0.0, height: sectionHeaderVw?.frame.size.height ?? 0.0))
        
        lblHeader.backgroundColor = UIColor.clear
        lblHeader.textColor = Constant.AppColor.colorAppTheme
        lblHeader.textAlignment = .left
        lblHeader.numberOfLines = 0
        lblHeader.contentMode = .bottom
        
        if section == 0 {
            lblHeader.font = Constant.AppFontHelper.defaultRegularFontWithSize(size: 15)
        } else {
            lblHeader.font = Constant.AppFontHelper.defaultSemiboldFontWithSize(size: 15)
        }
        
        lblHeader.text = sectionTitles[section]
        sectionHeaderVw?.addSubview(lblHeader)
        return sectionHeaderVw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableview(tableView, girlsDetailTableCell: indexPath)
    }
    
    func tableview(_ tableview: UITableView, girlsDetailTableCell indexPath : IndexPath) -> UITableViewCell {
        let cell = tblVw.deque(GirlsDetailTableCell.self, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        case 1:
            return 30
        case 2:
            return 30
        default:
            return 0.0
        }
    }

    
}
