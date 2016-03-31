//
//  AnalyzingTableViewCell.swift
//  Emonar
//
//  Created by ZengJintao on 3/29/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import YLProgressBar

class AnalyzingTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var progressBar: YLProgressBar!
    
    var progressPerc:CGFloat?
    var timer:NSTimer?
    var currentTime:NSDate?
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        
        infoLabel.text = "Recording"
        
        progressBar.type = .Flat
//        progressBar.indicatorTextLabel.text = "0s"
//        progressBar.indicatorTextDisplayMode = .Progress
        progressBar.stripesAnimationVelocity = 0.5
        progressPerc = 0.0
    }
    
    func progressStart(startTime:NSDate) {
        currentTime = startTime
        var timeIncrease = CGFloat((currentTime!.timeIntervalSinceNow * -1))
        if timeIncrease > 20 {
            progressPerc = 1
            progressBar.progress = progressPerc!
            infoLabel.text = "Analyzing"
        } else {
            progressPerc = timeIncrease * (1.03/20)
            progressBar.progress = progressPerc!
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "timerFinished:", userInfo: nil, repeats: true)
        }
    }
    
   

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func timerFinished(timer: NSTimer) {

        var timeIncrease = CGFloat((currentTime!.timeIntervalSinceNow * -1))
        if progressPerc < 1 {
            progressPerc = timeIncrease * (1.03/20)
            progressBar.progress = progressPerc!
            infoLabel.text = "Recording"
        } else {
            infoLabel.text = "Analyzing"
        }
        
    }

}
