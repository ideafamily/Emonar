//
//  RecordingViewController.swift
//  Emonar
//
//  Created by Gelei Chen on 11/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class RecordingTestViewController: UIViewController,EZAudioPlayerDelegate,EZMicrophoneDelegate,EZRecorderDelegate {
    
    @IBAction func playFile(_ sender: AnyObject) {
        //
        // Update microphone state
        //
        self.microphone.stopFetchingAudio()
        //
        // Update recording state
        //
        self.isRecording = false
        self.recordingStatusLabel.text = "Not Recording"
        self.recordSwitch.isOn = false
        //
        // Close the audio file
        //
        if (self.recorder != nil) {
            self.recorder.closeAudioFile()
        }
        let audioFile: EZAudioFile = EZAudioFile(url:self.testFilePathURL())
        self.player.playAudioFile(audioFile)
        
    }
    @IBOutlet weak var playingStateLabel: UILabel!
    @IBAction func toggleMicrophone(_ sender: AnyObject) {
        self.player.pause()
        let isOn: Bool = (sender as! UISwitch).isOn
        if !isOn {
            self.microphone.stopFetchingAudio()
        }
        else {
            self.microphone.startFetchingAudio()
        }
        
    }
    @IBAction func toggleRecoding(_ sender: AnyObject) {
        self.player.pause()
        if (sender as! UISwitch).isOn {
            //
            // Create the recorder
            //
            self.recordingAudioPlot.clear()
            self.microphone.startFetchingAudio()
            
            self.recorder = EZRecorder(url: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.WAV, delegate: self)
            self.playButton.isEnabled = true
        }
        self.isRecording = sender.isOn
        self.recordingStatusLabel.text = self.isRecording ? "Recording" : "Not Recording"
        
    }
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var recordSwitch: UISwitch!
    @IBOutlet weak var microphoneStateLabel: UILabel!
    @IBOutlet weak var microphoneSwitch: UISwitch!
    @IBOutlet weak var playingAudioPlot: EZAudioPlot!
    @IBOutlet weak var currentTimeLbael: UILabel!
    @IBOutlet weak var recordingAudioPlot: EZAudioPlotGL!
    
    let kAudioFilePath = "test.wav"
    var isRecording = false
    var microphone:EZMicrophone!
    var player:EZAudioPlayer!
    var recorder:EZRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        // Setup the AVAudioSession. EZMicrophone will not work properly on iOS
        // if you don't do this!
        //
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
        } catch {
            NSLog("Error setting up audio session category")
            NSLog("Error setting up audio session active")
        }
        
        
        // The output below is limited by 1 KB.
        // Please Sign Up (Free!) to remove this limitation.
        
        //
        // Customizing the audio plot that'll show the current microphone input/recording
        //
        self.recordingAudioPlot.backgroundColor = UIColor(red: 0.984, green: 0.71, blue: 0.365, alpha: 1)
        self.recordingAudioPlot.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.recordingAudioPlot.plotType = EZPlotType.rolling
        self.recordingAudioPlot.shouldFill = true
        self.recordingAudioPlot.shouldMirror = true
        //
        // Customizing the audio plot that'll show the playback
        //
        self.playingAudioPlot.color = UIColor.white
        self.playingAudioPlot.plotType = EZPlotType.rolling
        self.playingAudioPlot.shouldFill = true
        self.playingAudioPlot.shouldMirror = true
        self.playingAudioPlot.gain = 2.5
        // Create an instance of the microphone and tell it to use this view controller instance as the delegate
        self.microphone = EZMicrophone(delegate: self)
        self.player = EZAudioPlayer(delegate: self)
        //
        // Override the output to the speaker. Do this after creating the EZAudioPlayer
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch {
            NSLog("Error overriding output to the speaker")
        }
        //
        // Initialize UI components
        //
        self.microphoneStateLabel.text = "Microphone On"
        self.recordingStatusLabel.text = "Not Recording"
        self.playingStateLabel.text = "Not Playing"
        self.playButton.isEnabled = false
        //
        // Setup notifications
        //
        self.setupNotifications()
        //
        // Log out where the file is being written to within the app's documents directory
        //
        
        print("File written to application sandbox's documents directory: %@", self.testFilePathURL())
        //
        // Start the microphone
        //
        self.microphone.startFetchingAudio()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func microphone(_ microphone: EZMicrophone!, changedPlayingState isPlaying: Bool) {
        self.microphoneStateLabel.text = isPlaying ? "Microphone On" : "Microphone Off"
        self.microphoneSwitch.isOn = isPlaying
        
    }
    func recorderDidClose(_ recorder: EZRecorder!) {
        recorder.delegate = nil
    }
    func recorderUpdatedCurrentTime(_ recorder: EZRecorder!) {
        weak var weakSelf = self
        let formattedCurrentTime: String = recorder.formattedCurrentTime
        DispatchQueue.main.async(execute: {() -> Void in
            weakSelf!.currentTimeLbael.text = formattedCurrentTime
        })
        
    }
    @nonobjc func audioPlayer(_ audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, in audioFile: EZAudioFile!) {
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {() -> Void in
            weakSelf!.playingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
        
    }
    func audioPlayer(_ audioPlayer: EZAudioPlayer!, updatedPosition framePosition: Int64, in audioFile: EZAudioFile!) {
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {() -> Void in
            weakSelf!.currentTimeLbael.text = audioPlayer.formattedCurrentTime
        })
        
    }
    @nonobjc func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {() -> Void in
            //
            // All the audio plot needs is the buffer data (float*) and the size.
            // Internally the audio plot will handle all the drawing related code,
            // history management, and freeing its own resources. Hence, one badass
            // line of code gets you a pretty plot :)
            //
            weakSelf!.recordingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
        
    }
    func microphone(_ microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording {
            self.recorder.appendData(from: bufferList, withBufferSize: bufferSize)
        }
        
    }
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    
    func applicationDocuments() -> [AnyObject] {
        let nsDocumentDirectory = Foundation.FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = Foundation.FileManager.SearchPathDomainMask.userDomainMask
        return NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as [AnyObject]
        
    }
    //------------------------------------------------------------------------------
    
    func applicationDocumentsDirectory() -> String? {
        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true) as [AnyObject]
        if  paths.count > 0 {
            return paths[0] as? String
        }
        return nil
    }
    //------------------------------------------------------------------------------
    
    func testFilePathURL() -> URL {
        let content = "\(self.applicationDocumentsDirectory()!)/\(kAudioFilePath)"
        print("content :\(content)")
        return URL(fileURLWithPath: content)
    }
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(RecordingTestViewController.playerDidChangePlayState(_:)), name: NSNotification.Name.EZAudioPlayerDidChangePlayState, object: self.player)
        NotificationCenter.default.addObserver(self, selector: #selector(RecordingTestViewController.playerDidReachEndOfFile(_:)), name: NSNotification.Name.EZAudioPlayerDidReachEndOfFile, object: self.player)
    }
    func playerDidChangePlayState(_ notification: Notification) {
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {() -> Void in
            let player: EZAudioPlayer = notification.object as! EZAudioPlayer
            let isPlaying: Bool = player.isPlaying
            if isPlaying {
                weakSelf!.recorder.delegate = nil
            }
            weakSelf!.playingStateLabel.text = isPlaying ? "Playing" : "Not Playing"
            weakSelf!.playingAudioPlot.isHidden = !isPlaying
        })
    }
    func playerDidReachEndOfFile(_ notification: Notification) {
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {() -> Void in
            weakSelf!.playingAudioPlot.clear()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
