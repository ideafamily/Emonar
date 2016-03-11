//
//  RecordTableViewCell.swift
//  Emonar
//
//  Created by ZengJintao on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import Gifu

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emotionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var emotionImg: AnimatableImageView!

    @IBOutlet weak var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emotionImg.layer.cornerRadius = 3
        emotionImg.layer.masksToBounds = true
        
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
