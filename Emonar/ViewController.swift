//
//  ViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/1/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let recordManager = RecordManager.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //APIWrapper.sharedInstance.LoginAndAnalysis()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startRecord(sender: AnyObject) {
        recordManager.recordNewAudio()
    }
    
    @IBAction func startPlay(sender: AnyObject) {
        recordManager.startPlay()
    }
    
    @IBAction func stopRecord(sender: AnyObject) {
        recordManager.stopRecording()
    }
    @IBAction func stopPlaying(sender: AnyObject) {
        recordManager.stopPlaying()
    }
}

