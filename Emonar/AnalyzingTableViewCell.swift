//
//  AnalyzingTableViewCell.swift
//  Emonar
//
//  Created by ZengJintao on 3/29/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import YLProgressBar
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class AnalyzingTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var progressBar: YLProgressBar!
    
    var progressPerc:CGFloat?
    var timer:Timer?
    var currentTime:Date?
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        
        infoLabel.text = " Recording  "
        
        progressBar.type = .flat
//        progressBar.indicatorTextLabel.text = "0s"
//        progressBar.indicatorTextDisplayMode = .Progress
        progressBar.stripesAnimationVelocity = 0.5
        progressPerc = 0.0
    }
    
    func progressStart(_ startTime:Date) {
        currentTime = startTime
        let timeIncrease = CGFloat((currentTime!.timeIntervalSinceNow * -1))
        if timeIncrease > CGFloat(timeSpan) {
            progressPerc = 1
            progressBar.progress = progressPerc!
            infoLabel.text = " Analyzing  "
        } else {
            progressPerc = timeIncrease * CGFloat(1.03/timeSpan)
            progressBar.progress = progressPerc!
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AnalyzingTableViewCell.timerFinished(_:)), userInfo: nil, repeats: true)
        }
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func timerFinished(_ timer: Timer) {

        let timeIncrease = CGFloat((currentTime!.timeIntervalSinceNow * -1))
        if progressPerc < 1 {
            progressPerc = timeIncrease * CGFloat(1.03/timeSpan)
            progressBar.progress = progressPerc!
            infoLabel.text = " RECORDING  "
        } else {
            infoLabel.text = " ANALYZING  "
        }
        
    }

}
