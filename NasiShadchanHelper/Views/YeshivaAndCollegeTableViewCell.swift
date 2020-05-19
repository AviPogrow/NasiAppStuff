//
//  YeshivaAndCollegeTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by user on 5/4/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class YeshivaAndCollegeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var planLabel: UILabel!
    
     
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
           profileImageView.image = nil
           //ageLabel.text = nil
           heightLabel.text = nil
           planLabel.text = nil
           cityLabel.text = nil
           //koveahIttimLabel.backgroundColor = nil
           //
    }
    
    func thumbnail(for singleGirl: SingleGirl) -> UIImage {
       if singleGirl.hasPhoto, let image = singleGirl.photoImage {
         return image.resized(withBounds: CGSize(width: 52, height: 52))
       }
       return UIImage()
     }

}
