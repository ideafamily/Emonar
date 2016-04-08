//
//  ArchiveReplayViewController.swift
//  Emonar
//
//  Created by ZengJintao on 4/5/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class ArchiveReplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var playButton: UIButton!
    
    var audioName:String = ""
    var isPlaying:Bool!
    var playingIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
        playingIndex = 0
        isPlaying = false
        
        navigationItem.title = "hahah"
        navigationItem.backBarButtonItem?.title = "d"
//        navigationItem.titleView.
        let label = UILabel(frame: CGRectMake(0, 0, 1, 44))
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        label.text = "\(audioName)\n00:00"
        self.navigationItem.titleView = label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordTableViewCell", forIndexPath: indexPath) as! RecordTableViewCell
        cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
        if indexPath.row == playingIndex {
            //MARK: cell is playing
            cell.cardView.backgroundColor = UIColor.whiteColor()
        } else {
            //MARK: cell is not playing
            cell.cardView.backgroundColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    @IBAction func playButtonPressed(sender: UIButton) {
        if playButton.selected {
            //MARK: Start playing
            playButton.selected = false
        } else {
            //MARK: Pause playing
            playButton.selected = true
        }
    }

}
