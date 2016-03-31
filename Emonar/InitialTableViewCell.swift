//
//  InitialTableViewCell.swift
//  Emonar
//
//  Created by ZengJintao on 3/30/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class InitialTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
