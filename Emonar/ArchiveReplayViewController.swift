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
    var timer:Timer?
    
    var recordFiles : [RecordFile]!
    var audioData: [URL]!
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
        self.navigationController!.navigationBar.barTintColor = UIColor.black
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
        
        playingIndex = 0

        self.playingAudioPlot.backgroundColor = UIColor(red: 0.984, green: 0.71, blue: 0.365, alpha: 1)
        self.playingAudioPlot.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.playingAudioPlot.plotType = EZPlotType.rolling
        self.playingAudioPlot.shouldFill = true
        self.playingAudioPlot.shouldMirror = true
        self.playingAudioPlot.gain = 5


        customTitleView = LDONavigationSubtitleView(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
        customTitleView?.titleColor = UIColor.white
        customTitleView!.subtitle = "00:00"
        customTitleView!.title = "\(audioName)"
        
        
        let gRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTitle(_:)))
        customTitleView?.addGestureRecognizer(gRecognizer)
        customTitleView?.isUserInteractionEnabled = true
        navigationItem.titleView = customTitleView

    }
    
    func showChangeFileNameAlert() {
        let alertController = UIAlertController(title: "Change file name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (name:UITextField) -> Void in
            name.text = self.customTitleView?.title
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action:UIAlertAction) -> Void in
            let fileName = alertController.textFields![0].text
            self.customTitleView?.title = fileName
            FileManager.sharedInstance.changeRecordFileName(self.recordFileIndex, name: fileName!)
            
            
            //TODO: save the file
        }
        let deleteAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) -> Void in
            
        }
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    
    func didTapTitle(_ gesture: UIGestureRecognizer) {
        showChangeFileNameAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        cell.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        cell.emotionLabel.text = emotionData[indexPath.row].emotion
        cell.descriptionLabel.text = emotionData[indexPath.row].emotionDescription
        if indexPath.row == playingIndex {
            //MARK: cell is playing
            cell.cardView.backgroundColor = UIColor.white
        } else {
            //MARK: cell is not playing
            cell.cardView.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardSize
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var preIndex = playingIndex
        if playingIndex == cardSize {
            preIndex = cardSize - 1
        }
        playingIndex = indexPath.row
        recordTableView.reloadRows(at: [IndexPath(row: preIndex, section: 0)], with: .automatic)
        recordTableView.reloadRows(at: [IndexPath(row: playingIndex, section: 0)], with: .automatic)
        if isPaused {
            isPaused = false
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
        playButton.isSelected = true
        _ = playFile()
    }

    func playFile()->Bool{
        if audioData.count != 0 && playingIndex != cardSize {
            let audioFile: EZAudioFile = EZAudioFile(url:audioData[playingIndex])
            self.player.playAudioFile(audioFile)
            return true
        }
        return false
    }
    
    func audioPlayer(_ audioPlayer: EZAudioPlayer!, reachedEndOf audioFile: EZAudioFile!) {
        print("end of file at index \(self.playingIndex)")
        self.playingIndex += 1
        DispatchQueue.main.async {
            if self.playFile() {
                //Go to the next indexpath
                self.recordTableView.reloadRows(at: [IndexPath(row: self.playingIndex, section: 0)], with: .automatic)
                self.recordTableView.reloadRows(at: [IndexPath(row: self.playingIndex - 1, section: 0)], with: .automatic)
                self.recordTableView.scrollToRow(at: IndexPath(row: self.playingIndex, section: 0), at: .middle, animated: true)
            } else {
                //Audio ends
                self.playButton.isSelected = false
                self.isPaused = false
                self.timer?.invalidate()
            }
            
        }
        
    }
    @nonobjc func audioPlayer(_ audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, in audioFile: EZAudioFile!) {
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {() -> Void in
            weakSelf!.playingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
        
    }
    
    func updateTime(_ timer:Timer) {
        let currentTime = Tool.stringFromTimeInterval(player.currentTime.advanced(by: 1 + Double(playingIndex) * timeSpan))
        customTitleView?.subtitle = "\(currentTime)"
    }
    
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if playButton.isSelected {
            //MARK: Pause playing
            player.pause()
            playButton.isSelected = false
            isPaused = true
            timer?.invalidate()
            
        } else {
            //MARK: Start playing
            let currentTime = Tool.stringFromTimeInterval(player.currentTime.advanced(by: 1 + Double(playingIndex) * timeSpan))
            customTitleView?.subtitle = "\(currentTime)"
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
            if isPaused {
                
                isPaused = false
                player.play()
            } else {
                
                if playingIndex != 0 {
                    //when audio has been played to end
                    customTitleView?.subtitle = "00:00"
                    playingIndex = 0
                    recordTableView.reloadRows(at: [IndexPath(row: cardSize - 1, section: 0)], with: .automatic)
                    recordTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    recordTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                }
                _ = playFile()
                
            }
            
            
            playButton.isSelected = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        player.pause()
    }

}
