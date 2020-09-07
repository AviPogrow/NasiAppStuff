                                                                                                                                      //
//  SingleTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by user on 4/25/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class SingleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageHeightLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var SeminaryLabel: UILabel!
    @IBOutlet weak var parnassahPlanLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 11.0
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.35
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
         
         print("prepare for reuse invoked")
         nameLabel.text = nil
         ageHeightLabel.text = nil
         cityLabel.text = nil
         categoryLabel.text = nil
         SeminaryLabel.text = nil
         parnassahPlanLabel.text = nil
         profileImageView.image = nil
         
     }
}
