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
    
    var playingIndex:Int = 0
    var player:EZAudioPlayer!
    var currentIndex = 0
    
    var recordFiles : [RecordFile]!
    var audioData: [NSURL]!
    var emotionData : [EmotionData]!
    
    var endIndex:Int!
    var startIndex:Int!
    var cardSize:Int!
    
    var recordFileIndex:Int! {
        didSet{
            recordFiles = FileManager.sharedInstance.getAllLocalRecordFileFromStorage()
            audioData = recordFiles[recordFileIndex].audioArrayToNSURLArray()
            emotionData = recordFiles[recordFileIndex].sharedEmotionDataArray
            startIndex = 0
            endIndex = emotionData.count - 1
            currentIndex = startIndex
            cardSize = endIndex - startIndex + 1
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
        cell.emotionLabel.text = emotionData[indexPath.row].emotion
        cell.descriptionLabel.text = emotionData[indexPath.row].emotionDescription
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
        return cardSize
    }

    func playFile()->Bool{
        if audioData.count != 0 && self.currentIndex != self.recordFiles[recordFileIndex].sharedAduioArray.count {

            let audioFile: EZAudioFile = EZAudioFile(URL:audioData[self.currentIndex])
            self.player.playAudioFile(audioFile)

           
            return true
        }
        return false
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        print("end of file at index \(self.currentIndex)")
        self.currentIndex = self.currentIndex + 1
        dispatch_async(dispatch_get_main_queue()) {
            if self.playFile() {
                self.playingIndex += 1
                self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.playingIndex, inSection: 0)], withRowAnimation: .Automatic)
                self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.playingIndex - 1, inSection: 0)], withRowAnimation: .Automatic)
                self.recordTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.playingIndex, inSection: 0), atScrollPosition: .Middle, animated: true)
                
            } else {
                self.playButton.selected = false
                self.isPaused = false
                self.currentIndex = self.startIndex
            }
            
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
                if self.playingIndex != 0 {
                    //when audio has been played to end
                    self.playingIndex = 0
                    self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.cardSize - 1, inSection: 0)], withRowAnimation: .Automatic)
                    self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                    self.recordTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Bottom, animated: true)
                }
                playFile()
            }
            
            
            playButton.selected = true
        }
    }

}
