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
        player.pause()
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        
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
        customTitleView?.titleColor = UIColor.whiteColor()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var preIndex = playingIndex
        if playingIndex == cardSize {
            preIndex = cardSize - 1
        }
        playingIndex = indexPath.row
        recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: preIndex, inSection: 0)], withRowAnimation: .Automatic)
        recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: playingIndex, inSection: 0)], withRowAnimation: .Automatic)
        if isPaused {
            isPaused = false
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
        playButton.selected = true
        playFile()
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
        let currentTime = Tool.stringFromTimeInterval(player.currentTime.advancedBy(1 + Double(playingIndex) * timeSpan))
        customTitleView?.subtitle = "\(currentTime)"
    }
    
    
    
    @IBAction func playButtonPressed(sender: UIButton) {
        if playButton.selected {
            //MARK: Pause playing
            player.pause()
            playButton.selected = false
            isPaused = true
            timer?.invalidate()
            
        } else {
            //MARK: Start playing
            let currentTime = Tool.stringFromTimeInterval(player.currentTime.advancedBy(1 + Double(playingIndex) * timeSpan))
            customTitleView?.subtitle = "\(currentTime)"
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
            if isPaused {
                
                isPaused = false
                player.play()
            } else {
                
                if playingIndex != 0 {
                    //when audio has been played to end
                    customTitleView?.subtitle = "00:00"
                    playingIndex = 0
                    recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: cardSize - 1, inSection: 0)], withRowAnimation: .Automatic)
                    recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                    recordTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Bottom, animated: true)
                }
                playFile()
                
            }
            
            
            playButton.selected = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        player.pause()
    }

}
