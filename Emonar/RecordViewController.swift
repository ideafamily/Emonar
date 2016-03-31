//
//  RecordViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
//import Gifu


class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EZMicrophoneDelegate, EZRecorderDelegate, EZAudioPlayerDelegate {

    
    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var soundWaveView: EZAudioPlotGL!
    
    @IBOutlet weak var recordButton: UIButton!
    

    struct data {
        var emotion = "Analyzing"
        var analyzed = false
        var startTime:NSDate?
    }
    
    var datas:[data] = [data()]
    var datasIndex = 0
    
    var timer:NSTimer?

    var isRecording:Bool = false



    let fileManager = FileManager.sharedInstance
    var microphone:EZMicrophone!
    var recorder: EZRecorder!
    var player: EZAudioPlayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
        } catch {
            NSLog("Error setting up audio session category")
            NSLog("Error setting up audio session active")
        }
        
        self.soundWaveView.backgroundColor = UIColor(red: 0.984, green: 0.71, blue: 0.365, alpha: 1)
        self.soundWaveView.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.soundWaveView.plotType = EZPlotType.Rolling
        self.soundWaveView.shouldFill = true
        self.soundWaveView.shouldMirror = true

        self.microphone = EZMicrophone(delegate: self)
        self.player = EZAudioPlayer(delegate: self)
        //
        // Override the output to the speaker. Do this after creating the EZAudioPlayer
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch {
            NSLog("Error overriding output to the speaker")
        }
        
 

        self.navigationController?.navigationBarHidden = true
        
        recordTableView.delegate = self
        recordTableView.dataSource = self

        recordTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        recordButton.selected = false

        // Do any additional setup after loading the view.
        fileManager.deleteFileFromStorate(1)
        let array = fileManager.getAllLocalFileStorage()
        for elemtn in array! {
            print(elemtn)
        }
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
            weakSelf!.soundWaveView.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
        
    }
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording {
            self.recorder.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && !isRecording {
                //Initial cell
                let cell = tableView.dequeueReusableCellWithIdentifier("InitialTableViewCell", forIndexPath: indexPath) as! InitialTableViewCell
                cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
                return cell
        }
        
        if datas[datas.count-1-indexPath.row].analyzed {
            //Result cell
            let cell = tableView.dequeueReusableCellWithIdentifier("RecordTableViewCell", forIndexPath: indexPath) as! RecordTableViewCell
            cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
            cell.emotionLabel.text = datas[datas.count-1-indexPath.row].emotion
            
            cell.emotionImg.image = UIImage(named: "temp")
            return cell
        } else {
            //Recording and Analyzing cell
            let cell = tableView.dequeueReusableCellWithIdentifier("AnalyzingTableViewCell", forIndexPath: indexPath) as! AnalyzingTableViewCell
            cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
            cell.progressStart(datas[datas.count-1-indexPath.row].startTime!)
            print("cell: \(cell.progressPerc)")
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 125
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            cell.alpha = 1
        }
    }
    
    
    
    @IBAction func cancelPressed(sender: UIButton) {
        if recordButton.selected {
            recordButton.selected = false
            timer?.invalidate()
            showSaveAlert()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func recordPressed(sender: UIButton) {

        if sender.selected == true {
            recordTableView.userInteractionEnabled = true
            sender.selected = false
            timer!.invalidate()
            isRecording = false
            self.microphone.stopFetchingAudio()
            if (self.recorder != nil) {
                self.recorder.closeAudioFile()
                fileManager.insertFileToStorage(testFilePathURL())
            }
            recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
            print("fff")
            showSaveAlert()
        } else {
//            recordTableView.userInteractionEnabled = false
            sender.selected = true
            isRecording = true
            self.microphone.startFetchingAudio()
            self.recorder = EZRecorder(URL: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.WAV, delegate: self)
            if datas.count > 1 {
                datas.removeAll()
                datas.append(data())
                
            }
            datas[0].startTime = NSDate()
            datasIndex = 0
            recordTableView.reloadData()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "timerFinished:", userInfo: nil, repeats: true)
        }
    }
    
    func applicationDocumentsDirectory() -> String? {
        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if  paths.count > 0 {
            return paths[0] as? String
        }
        return nil
    }
    
    func testFilePathURL() -> NSURL {
        let content = "\(self.applicationDocumentsDirectory()!)/\(fileManager.getNumberOfFile()).wav"
        print("content :\(content)")
        return NSURL.fileURLWithPath(content)
    }
    
    func timerFinished(timer: NSTimer) {
        var localIndex = datasIndex
        delay(3) { () -> () in
            //MARK: change data and reload cell while api calls back
                self.datas[localIndex].emotion = "changed\(localIndex)"
                self.datas[localIndex].analyzed = true
                self.recordTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.datas.count - localIndex - 1, inSection: 0)], withRowAnimation: .Automatic)
        }
        datas.append(data(emotion: "Analyzing\(datasIndex++)", analyzed: false, startTime: NSDate()))
        print("add: \(datas)")
//=======
//            //stop recording
//            sender.selected = false
//            self.isRecording = false
//            self.microphone.stopFetchingAudio()
//            if (self.recorder != nil) {
//                self.recorder.closeAudioFile()
//                fileManager.insertFileToStorage(testFilePathURL())
//            }
//            timer?.invalidate()
//        } else {
//            //start recording
//            sender.selected = true
//            self.microphone.startFetchingAudio()
//            timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "timerFinished:", userInfo: nil, repeats: true)
//            self.recorder = EZRecorder(URL: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.WAV, delegate: self)
//            let a = 
//            self.isRecording = true;
//        }
//    }
//    
////
////    func applicationDocumentsDirectory() -> String? {
////        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
////        if  paths.count > 0 {
////            return paths[0] as? String
////        }
////        return nil
////    }
//    //------------------------------------------------------------------------------
//    
////    func testFilePathURL() -> NSURL {
////        let content = "\(self.applicationDocumentsDirectory()!)/\(fileManager.getNumberOfFile()).wav"
////        print("content :\(content)")
////        return NSURL.fileURLWithPath(content)
////    }
//    func timerFinished(timer: NSTimer) {
////        let a = temp
////        delay(3) { () -> () in
////            self.data[a] = "changed\(a)"
//////            self.recordTableView.reloadData()
////        }
//        data.append("WOWww")
////        print(data)
//>>>>>>> master
        recordTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Left)
        //self.isRecording = false;
        if (self.recorder != nil) {
            self.recorder.closeAudioFile()
            fileManager.insertFileToStorage(testFilePathURL())
            self.recorder = EZRecorder(URL: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.WAV, delegate: self)
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    deinit {
        self.recordTableView = nil
    }
    
    func resetCellInRow(row: Int) {
        let cell = recordTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! AnalyzingTableViewCell
        cell.progressPerc = 0
        cell.progressBar.progress = 0
        cell.infoLabel.text = "Recording"
    }
    
    func resetAllData() {
        //1. delete all previous data
        datas.removeAll()
        
        //2. initial data
        datas.append(data())
        datasIndex = 0
        
        //3. reload data
        recordTableView.reloadData()
    }

    func showSaveAlert() {
        let alertController = UIAlertController(title: "Save your record?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (name:UITextField) -> Void in
            name.text = "New file"
        }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action:UIAlertAction) -> Void in
            let fileName = alertController.textFields![0].text
            print("save file: \(fileName)")
            //TODO: save the file
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Default) { (action:UIAlertAction) -> Void in
            //TODO: delete the file
//            self.resetAllData()
        }
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
