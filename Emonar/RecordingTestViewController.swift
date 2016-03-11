//
//  RecordingViewController.swift
//  Emonar
//
//  Created by Gelei Chen on 11/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class RecordingTestViewController: UIViewController,EZAudioPlayerDelegate,EZMicrophoneDelegate,EZRecorderDelegate {

    @IBAction func playFile(sender: AnyObject) {
        //
        // Update microphone state
        //
        self.microphone.stopFetchingAudio()
        //
        // Update recording state
        //
        self.isRecording = false
        self.recordingStatusLabel.text = "Not Recording"
        self.recordSwitch.on = false
        //
        // Close the audio file
        //
        if (self.recorder != nil) {
            self.recorder.closeAudioFile()
        }
        let audioFile: EZAudioFile = EZAudioFile(URL:self.testFilePathURL())
        self.player.playAudioFile(audioFile)

    }
    @IBOutlet weak var playingStateLabel: UILabel!
    @IBAction func toggleMicrophone(sender: AnyObject) {
        self.player.pause()
        let isOn: Bool = (sender as! UISwitch).on
        if !isOn {
            self.microphone.stopFetchingAudio()
        }
        else {
            self.microphone.startFetchingAudio()
        }

    }
    @IBAction func toggleRecoding(sender: AnyObject) {
        self.player.pause()
        if (sender as! UISwitch).on {
            //
            // Create the recorder
            //
            self.recordingAudioPlot.clear()
            self.microphone.startFetchingAudio()
            
            self.recorder = EZRecorder(URL: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)
            self.playButton.enabled = true
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
    
    let kAudioFilePath = "test.m4a"
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
        self.recordingAudioPlot.plotType = EZPlotType.Rolling
        self.recordingAudioPlot.shouldFill = true
        self.recordingAudioPlot.shouldMirror = true
        //
        // Customizing the audio plot that'll show the playback
        //
        self.playingAudioPlot.color = UIColor.whiteColor()
        self.playingAudioPlot.plotType = EZPlotType.Rolling
        self.playingAudioPlot.shouldFill = true
        self.playingAudioPlot.shouldMirror = true
        self.playingAudioPlot.gain = 2.5
        // Create an instance of the microphone and tell it to use this view controller instance as the delegate
        self.microphone = EZMicrophone(delegate: self)
        self.player = EZAudioPlayer(delegate: self)
        //
        // Override the output to the speaker. Do this after creating the EZAudioPlayer
        do {
           try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch {
            NSLog("Error overriding output to the speaker")
        }
        //
        // Initialize UI components
        //
        self.microphoneStateLabel.text = "Microphone On"
        self.recordingStatusLabel.text = "Not Recording"
        self.playingStateLabel.text = "Not Playing"
        self.playButton.enabled = false
        //
        // Setup notifications
        //
        self.setupNotifications()
        //
        // Log out where the file is being written to within the app's documents directory
        //
        NSLog("File written to application sandbox's documents directory: %@", self.testFilePathURL())
        //
        // Start the microphone
        //
        self.microphone.startFetchingAudio()

        
        // Do any additional setup after loading the view.
    }
    
    
    func microphone(microphone: EZMicrophone!, changedPlayingState isPlaying: Bool) {
        self.microphoneStateLabel.text = isPlaying ? "Microphone On" : "Microphone Off"
        self.microphoneSwitch.on = isPlaying

    }
    func recorderDidClose(recorder: EZRecorder!) {
        recorder.delegate = nil
    }
    func recorderUpdatedCurrentTime(recorder: EZRecorder!) {
        weak var weakSelf = self
        let formattedCurrentTime: String = recorder.formattedCurrentTime
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            weakSelf!.currentTimeLbael.text = formattedCurrentTime
        })

    }
    func audioPlayer(audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, inAudioFile audioFile: EZAudioFile!) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            weakSelf!.playingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })

    }
    func audioPlayer(audioPlayer: EZAudioPlayer!, updatedPosition framePosition: Int64, inAudioFile audioFile: EZAudioFile!) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            weakSelf!.currentTimeLbael.text = audioPlayer.formattedCurrentTime
        })

    }
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            //
            // All the audio plot needs is the buffer data (float*) and the size.
            // Internally the audio plot will handle all the drawing related code,
            // history management, and freeing its own resources. Hence, one badass
            // line of code gets you a pretty plot :)
            //
            weakSelf!.recordingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })

    }
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording {
            self.recorder.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }

    }
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    
    func applicationDocuments() -> [AnyObject] {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        return NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
    }
    //------------------------------------------------------------------------------
    
    func applicationDocumentsDirectory() -> String? {
        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if  paths.count > 0 {
            return paths[0] as? String
        }
        return nil
    }
    //------------------------------------------------------------------------------
    
    func testFilePathURL() -> NSURL {
        let content = "\(self.applicationDocumentsDirectory()!)/\(kAudioFilePath)"
        print("content :\(content)")
        return NSURL.fileURLWithPath(content)
    }
    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidChangePlayState:", name: EZAudioPlayerDidChangePlayStateNotification, object: self.player)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidReachEndOfFile:", name: EZAudioPlayerDidReachEndOfFileNotification, object: self.player)
    }
    func playerDidChangePlayState(notification: NSNotification) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            let player: EZAudioPlayer = notification.object as! EZAudioPlayer
            let isPlaying: Bool = player.isPlaying
            if isPlaying {
                weakSelf!.recorder.delegate = nil
            }
            weakSelf!.playingStateLabel.text = isPlaying ? "Playing" : "Not Playing"
            weakSelf!.playingAudioPlot.hidden = !isPlaying
        })
    }
    func playerDidReachEndOfFile(notification: NSNotification) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
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
