//
//  NotesTableCell.swift
//  NasiShadchanHelper
//
//  Created by apple on 08/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class NotesTableCell: UITableViewCell {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwHeaderBg: UIView!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var lblDots: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblDots.addRoundedViewCorners(width: lblDots.frame.size.height/2, colorBorder: .clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
