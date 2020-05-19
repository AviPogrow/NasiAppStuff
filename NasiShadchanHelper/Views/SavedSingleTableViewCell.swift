//
//  SavedSingleTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by user on 5/8/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class SavedSingleTableViewCell: UITableViewCell {
    
     @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for singleGirl: SingleGirl) {
        nameLabel.text = singleGirl.firstName + " " + singleGirl.lastName
        categoryLabel.text = singleGirl.category
        ageLabel.text = singleGirl.age
        cityLabel.text = singleGirl.city
        
        profileImageView.contentMode = .scaleAspectFit
        
        let imageNameRaw = singleGirl.imageName
        let fixedImageName = imageNameRaw.replacingOccurrences(of: " ", with: "")
        
        let image = UIImage(named: fixedImageName)
        if image != nil {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "face02")
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        profileImageView.image = nil
        categoryLabel.text = nil
        cityLabel.text = nil
        ageLabel.text = nil 
    }

}
