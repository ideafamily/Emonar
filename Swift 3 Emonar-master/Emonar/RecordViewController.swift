//
//  RecordViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

var timeSpan = 10.0


class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EZMicrophoneDelegate, EZRecorderDelegate, EZAudioPlayerDelegate {

    
    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var soundWaveView: EZAudioPlotGL!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var fileNameLabel: UILabel!

    
    var datas:[EmotionData] = [EmotionData(emotion: "Analyzing", emotionDescription: "Sorry, Emonar doesn't understand your current emotion.Maybe input voice is too low", analyzed: false, startTime: nil)]
    var datasIndex = 0
    
    var timer:Timer?

    var isRecording:Bool = false



    let fileManager = FileManager.sharedInstance
    var microphone:EZMicrophone!
    var recorder: EZRecorder!
    var player: EZAudioPlayer!
    
    var beginTime:Date!
    

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
        self.soundWaveView.plotType = EZPlotType.rolling
        self.soundWaveView.shouldFill = true
        self.soundWaveView.shouldMirror = true
        self.soundWaveView.gain = 5
        self.microphone = EZMicrophone(delegate: self)
        self.player = EZAudioPlayer(delegate: self)
        //
        // Override the output to the speaker. Do this after creating the EZAudioPlayer
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch {
            NSLog("Error overriding output to the speaker")
        }
        
 

        self.navigationController?.isNavigationBarHidden = true
        
        recordTableView.delegate = self
        recordTableView.dataSource = self

        recordTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
        recordButton.isSelected = false

        // Do any additional setup after loading the view.
        
    }

    @nonobjc func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        weak var weakSelf = self
        runOnMainThread { 
            //
            // All the audio plot needs is the buffer data (float*) and the size.
            // Internally the audio plot will handle all the drawing related code,
            // history management, and freeing its own resources. Hence, one badass
            // line of code gets you a pretty plot :)
            //
            weakSelf!.soundWaveView.updateBuffer(buffer[0], withBufferSize: bufferSize)
        }
        
    }
    func microphone(_ microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording && self.recorder != nil {
            self.recorder.appendData(from: bufferList, withBufferSize: bufferSize)
        }
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 && !isRecording {
                //Initial cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell", for: indexPath) as! InitialTableViewCell
                cell.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            
            
                return cell
        }
        
        if datas[datas.count-1-indexPath.row].analyzed {
            //Result cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            cell.emotionLabel.text = datas[datas.count-1-indexPath.row].emotion
            cell.descriptionLabel.text = datas[datas.count-1-indexPath.row].emotionDescription
            cell.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            return cell
        } else {
            //Recording and Analyzing cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyzingTableViewCell", for: indexPath) as! AnalyzingTableViewCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            cell.progressStart(datas[datas.count-1-indexPath.row].startTime!)
            cell.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 125
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            cell.alpha = 1
        }) 
    }
    
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        if isRecording {
            self.microphone.stopFetchingAudio()
            
            if (self.recorder != nil) {
                self.recorder.closeAudioFile()
            }
            recordButton.isSelected = false
            timer?.invalidate()
            let elapsedTime = Date().timeIntervalSince(self.beginTime)
            isRecording = false
            self.recordTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            showSaveAlert(Tool.stringFromTimeInterval(elapsedTime))
            
        } else {
            self.dismiss(animated: true, completion: nil)
        
        }
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        if !Tool.isConnectedToNetwork() {
            let alertController = UIAlertController(title: "Please check your network connection", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            if sender.isSelected == true {
                sender.isSelected = false
                timer!.invalidate()
                isRecording = false
                
                let elapsedTime = Date().timeIntervalSince(self.beginTime)
                self.microphone.stopFetchingAudio()
                
                if (self.recorder != nil) {
                    self.recorder.closeAudioFile()
                }
                runOnMainThread({
                    self.recordTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.showSaveAlert(Tool.stringFromTimeInterval(elapsedTime))
                })
                
            } else {
                self.beginTime = Date()
                sender.isSelected = true
                isRecording = true
                self.microphone.startFetchingAudio()
                self.recorder = EZRecorder(url: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.WAV, delegate: self)
                if datas.count > 1 {
                    datas.removeAll()
                    let currentData = EmotionData(emotion: "Analyzing", emotionDescription: "Sorry, Emonar doesn't understand your current emotion.Maybe input voice is too low", analyzed: false, startTime: nil)
                    datas.append(currentData)
                    
                    
                }
                datas[0].startTime = Date()
                datasIndex = 0
                runOnMainThread({
                    self.recordTableView.reloadData()
                })
                
                timer = Timer.scheduledTimer(timeInterval: timeSpan, target: self, selector: #selector(RecordViewController.timerFinished(_:)), userInfo: nil, repeats: true)
            }

        }
        
        
    }
    func runOnMainThread(_ block: @escaping () -> Void){
        DispatchQueue.main.async { 
            block()
        }
    }
    
    func applicationDocumentsDirectory() -> String? {
        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true) as [AnyObject]
        if  paths.count > 0 {
            return paths[0] as? String
        }
        return nil
    }
    func filePath()->String{
        return "\(self.applicationDocumentsDirectory()!)/\(fileManager.getAudioIndex()).wav"
    }
    func testFilePathURL() -> URL {
//        print("content :\(content)")
        return URL(fileURLWithPath: filePath())
    }
    
    func localFilePath() -> String {
        return "/\(fileManager.getAudioIndex()).wav"
    }
    
    func timerFinished(_ timer: Timer) {
        let localIndex = datasIndex
        let currentData = EmotionData(emotion: "Analyzing\(datasIndex)",emotionDescription: "Description", analyzed: false, startTime: Date())
        
        datas.append(currentData)
        datasIndex += 1
        runOnMainThread({
            self.recordTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
        })
        
        
        APIWrapper.sharedInstance.startAnSessionAndSendAFile(filePath(), completion: { (object:Analysis_result_analysisSegments?) in
            if object != nil {
                let description = String.addString([object!.analysis.Mood.Composite.Secondary.Phrase,object!.analysis.Mood.Group11.Primary.Phrase,object!.analysis.Mood.Group11.Secondary.Phrase])
                let modifiedDescription = description.substring(from: description.characters.index(description.startIndex, offsetBy: 1))
                self.updateData(localIndex, content: object!.analysis.Mood.Composite.Primary.Phrase, description: modifiedDescription)
            } else {
                self.updateData(localIndex, content: "No Result", description: "Sorry, Emonar doesn't understand your current emotion.Maybe input voice is too low.")
            }
            
        })
        if (self.recorder != nil && self.isRecording) {
            self.isRecording = false
            self.recorder.closeAudioFile()
            fileManager.insertAudioToStorage(localFilePath())
            self.recorder = EZRecorder(url: self.testFilePathURL(), clientFormat: self.microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.WAV, delegate: self)
            isRecording = true
        }
        
    }
    func updateData(_ localIndex:Int,content:String,description:String){
        self.datas[localIndex].emotion = String.trimString(content)
        self.datas[localIndex].analyzed = true
        self.datas[localIndex].emotionDescription = description
        let emotionData = self.datas[localIndex]
        self.fileManager.insertEmotionDataToStorage(emotionData)
        
        runOnMainThread({ 
            self.recordTableView.reloadRows(at: [IndexPath(row: self.datas.count - localIndex - 1, section: 0)], with: .automatic)
        })

    }

    deinit {
        self.recordTableView = nil
    }
    
   
    
    func resetAllData() {
        //1. delete all previous data
        datas.removeAll()
        
        //2. initial data
        datas.append(EmotionData(emotion: "Analyzing", emotionDescription: "Sorry, Emonar doesn't understand your current emotion.Maybe input voice is too low", analyzed: false, startTime: nil))
        datasIndex = 0
        
        //3. reload data
        runOnMainThread { 
            self.recordTableView.reloadData()
        }
        
    }

    func showSaveAlert(_ recordLength:String) {
        let alertController = UIAlertController(title: "Save your record?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (name:UITextField) -> Void in
            name.text = "New file"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action:UIAlertAction) -> Void in
            let fileName = alertController.textFields![0].text
            print("save file: \(fileName!)")
            self.fileManager.insertRecordFileToStorage(fileName!,recordLength: recordLength)
            self.fileNameLabel.text = fileName!
            self.timer?.invalidate()
            //TODO: save the file
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction) -> Void in
            //TODO: delete the file
            self.timer?.invalidate()
            
//            serlf.resetAllData()
        }
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
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
