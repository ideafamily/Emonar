//
//  ArchiveReplayViewController.swift
//  Emonar
//
//  Created by ZengJintao on 4/5/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import LDONavigationSubtitleView

class ArchiveReplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,EZAudioPlayerDelegate {

    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var playingAudioPlot: EZAudioPlotGL!
    @IBOutlet weak var playButton: UIButton!
    
    var audioName:String = ""
    var isPaused:Bool = false
    
    var playingIndex:Int = 0
    var player:EZAudioPlayer!
    var timer:NSTimer?
    var playingTime:Int = 0
    
    var recordFiles : [RecordFile]!
    var audioData: [NSURL]!
    var emotionData : [EmotionData]!
    
    var cardSize:Int!
    
    var customTitleView:LDONavigationSubtitleView?
    
    var recordFileIndex:Int! {
        didSet{
            recordFiles = FileManager.sharedInstance.getAllLocalRecordFileFromStorage()
            audioData = recordFiles[recordFileIndex].audioArrayToNSURLArray()
            emotionData = recordFiles[recordFileIndex].sharedEmotionDataArray
            cardSize = emotionData.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player = EZAudioPlayer(delegate: self)
//        self.navigationController.
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
        playingIndex = 0

        self.playingAudioPlot.backgroundColor = UIColor(red: 0.984, green: 0.71, blue: 0.365, alpha: 1)
        self.playingAudioPlot.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.playingAudioPlot.plotType = EZPlotType.Rolling
        self.playingAudioPlot.shouldFill = true
        self.playingAudioPlot.shouldMirror = true
        self.playingAudioPlot.gain = 5


        customTitleView = LDONavigationSubtitleView(frame: CGRectMake(0, 0, 300, 44))
        customTitleView!.subtitle = "00:00"
        customTitleView!.title = "\(audioName)"
        navigationItem.titleView = customTitleView

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
        if audioData.count != 0 && playingIndex != cardSize {
            let audioFile: EZAudioFile = EZAudioFile(URL:audioData[playingIndex])
            self.player.playAudioFile(audioFile)
            
            return true
        }
        return false
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        print("end of file at index \(self.playingIndex)")
        self.playingIndex += 1
        dispatch_async(dispatch_get_main_queue()) {
            if self.playFile() {
                //Go to the next indexpath
                self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.playingIndex, inSection: 0)], withRowAnimation: .Automatic)
                self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.playingIndex - 1, inSection: 0)], withRowAnimation: .Automatic)
                self.recordTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.playingIndex, inSection: 0), atScrollPosition: .Middle, animated: true)
            } else {
                //Audio ends
                self.playButton.selected = false
                self.isPaused = false
                self.timer?.invalidate()
            }
            
        }
        
    }
    func audioPlayer(audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, inAudioFile audioFile: EZAudioFile!) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            weakSelf!.playingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
        
    }
    
    func updateTime(timer:NSTimer) {
        playingTime += 1
        let (h, m, s) = Tool.secondsToHoursMinutesSeconds(playingTime)
//        navigationItem.titleView
        customTitleView?.subtitle = "\(m):\(s)"
        print("\(m):\(s)")
    }
    
    
    
    @IBAction func playButtonPressed(sender: UIButton) {
        if playButton.selected {
            //MARK: Pause playing
            self.player.pause()
            playButton.selected = false
            self.isPaused = true
        } else {
            //MARK: Start playing
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
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
                playFile()
                
            }
            
            
            playButton.selected = true
        }
    }

}
