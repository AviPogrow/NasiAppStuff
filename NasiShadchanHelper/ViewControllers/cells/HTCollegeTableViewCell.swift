//
//  HTCollegeTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by user on 5/6/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class HTCollegeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageHeightLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var seminaryLabel: UILabel!
    @IBOutlet weak var professionalTrackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*layer.masksToBounds = true
        layer.cornerRadius = 11.0
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.35*/
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        print("prepare for reuse invoked")
        nameLabel.text = nil
        profileImageView.image = nil
        cityLabel.text = nil
        ageHeightLabel.text = nil
        seminaryLabel.text = nil
        categoryLabel.text = nil
        professionalTrackLabel.text = nil 
    }
}
