//
//  RecordTableViewCell.swift
//  Emonar
//
//  Created by ZengJintao on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
//import Gifu

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emotionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    

    @IBOutlet weak var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
