//
//  FTCollegeTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by user on 5/4/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class FTCollegeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageHeightLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var seminaryLabel: UILabel!
    @IBOutlet weak var koveahIttimLabel: UILabel!
    
    
      override func awakeFromNib() {
          super.awakeFromNib()
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        
        print("prepare for reuse invoked")
        nameLabel.text = nil
        profileImageView.image = nil
        ageHeightLabel.text = nil
        seminaryLabel.text = nil
        cityLabel.text = nil
        categoryLabel.text = nil
        koveahIttimLabel.text = nil
        koveahIttimLabel.backgroundColor = nil
        koveahIttimLabel.textColor = nil
    }

}
