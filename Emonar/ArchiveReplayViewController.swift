//
//  ArchiveReplayViewController.swift
//  Emonar
//
//  Created by ZengJintao on 4/5/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class ArchiveReplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,EZAudioPlayerDelegate {

    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var playButton: UIButton!
    
    var audioName:String = ""
    var isPaused:Bool = false
    
    var playingIndex:Int!
    var player:EZAudioPlayer!
    var currentIndex = 0
    
    var recordFiles : [RecordFile]!
    var audioData: [NSURL]!
    var emotionData : [EmonationData]!
    
    
    
    var recordFileIndex:Int! {
        didSet{
            recordFiles = FileManager.sharedInstance.getAllLocalRecordFileFromStorage()
            audioData = FileManager.sharedInstance.getAllLocalAudioFileFromStorage()
            emotionData = FileManager.sharedInstance.getAllLocalEmotionDateFromStorage()
            currentIndex = recordFiles[recordFileIndex].startIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player = EZAudioPlayer(delegate: self)
        
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
        playingIndex = 0
        
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
    func playFile(){
        if audioData.count != 0 && self.currentIndex != self.recordFiles[recordFileIndex].endIndex+1 {
            let audioFile: EZAudioFile = EZAudioFile(URL:audioData[self.currentIndex])
            self.player.playAudioFile(audioFile)
        }
    }
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        print("end of file at index \(self.currentIndex)")
        self.currentIndex = self.currentIndex + 1
        dispatch_async(dispatch_get_main_queue()) {
            self.playFile()
        }
        
    }
    @IBAction func playButtonPressed(sender: UIButton) {
        if playButton.selected {
            //MARK: Pause playing
            self.player.pause()
            playButton.selected = false
            self.isPaused = true
        } else {
            //MARK: Star playing
            if isPaused {
                self.isPaused = false
                self.player.play()
            } else {
                playFile()
            }
            
            
            playButton.selected = true
        }
    }

}
