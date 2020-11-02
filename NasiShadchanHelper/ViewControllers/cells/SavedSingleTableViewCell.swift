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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        profileImageView.image = nil
        categoryLabel.text = nil
        cityLabel.text = nil
        ageLabel.text = nil 
    }
    
    func configure(for singleGirl: NasiGirlsList) {
        nameLabel.text = (singleGirl.firstNameOfGirl ?? "") + " " + (singleGirl.lastNameOfGirl ?? "")
        categoryLabel.text = singleGirl.category
        ageLabel.text = "\(singleGirl.dateOfBirth ?? 0.0)"
        cityLabel.text = singleGirl.cityOfResidence
        
        profileImageView.contentMode = .scaleAspectFit
        
        if (singleGirl.imageDownloadURLString ?? "").isEmpty {
            print("this is empty....", singleGirl.imageDownloadURLString ?? "")
            profileImageView?.image = UIImage.init(named: "placeholder")
        } else {
            profileImageView.loadImageFromUrl(strUrl: String(format: "%@",singleGirl.imageDownloadURLString!), imgPlaceHolder: "placeholder")
            print("this is not empty....", singleGirl.imageDownloadURLString ?? "")
        }
        
        /*
         let imageNameRaw = singleGirl.imageName
         let fixedImageName = imageNameRaw.replacingOccurrences(of: " ", with: "")
         
         let image = UIImage(named: fixedImageName)
         if image != nil {
         profileImageView.image = image
         } else {
         profileImageView.image = UIImage(named: "face02")
         }
         */
        
    }
}
