//
//  MainViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/10/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import ProgressHUD


class MainViewController: UIViewController,EZAudioPlayerDelegate {

    var player:EZAudioPlayer!
    
    @IBOutlet weak var phoneCallButton: UIButton!
    @IBAction func gotoRecord(sender: AnyObject) {
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    @IBAction func phonePressed(sender: AnyObject) {
        playFile()
        
    }
    func playFile(){
        if files.count != 0 && self.currentIndex != self.files.count {
            let audioFile: EZAudioFile = EZAudioFile(URL:files[self.currentIndex])
            self.player.playAudioFile(audioFile)
        }
    }
    
    
    @IBAction func gotoArchive(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoArchive", sender: self)
    }
    var currentIndex = 0
    var files : [NSURL]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = EZAudioPlayer(delegate: self)
        Tool.showProgressHUD("Log in")
        APIWrapper.sharedInstance.loginWithCallback({
            Tool.dismissHUD()
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
//        files = FileManager.sharedInstance.getAllLocalFileStorage()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        print("end of file at index \(self.currentIndex)")
        self.currentIndex = self.currentIndex + 1
        dispatch_async(dispatch_get_main_queue()) {
            self.playFile()
        }
        
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
