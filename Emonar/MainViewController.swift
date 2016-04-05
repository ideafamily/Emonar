//
//  MainViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/10/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import ProgressHUD


class MainViewController: UIViewController {
    //var player =  AVAudioPlayer()
    
    @IBAction func gotoRecord(sender: AnyObject) {
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    @IBAction func phonePressed(sender: AnyObject) {
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch {
            NSLog("Error setting up audio session category")
            NSLog("Error setting up audio session active")
        }
        
        

        let files = FileManager.sharedInstance.getAllLocalFileStorage()
        print(files![0])
        let path = NSBundle.mainBundle().pathForResource("sample", ofType:"wav")!
        let url = NSURL(fileURLWithPath: path)
        
        let player = EZAudioPlayer()
        player.playAudioFile(EZAudioFile(URL: url))
//        print(url)
//        do {
//            //let sound = try AVAudioPlayer(contentsOfURL: files![0])
//            
//            //sound.play()
//            let player = try AVAudioPlayer(contentsOfURL: url)
//            player.prepareToPlay()
//            player.play()
//        } catch {
//            print("bao le");
//            // couldn't load file :(
//        }
    }
    
    
    
    @IBAction func gotoArchive(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoArchive", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Tool.showProgressHUD("Log in")
        APIWrapper.sharedInstance.loginWithCallback({
            Tool.dismissHUD()
        })
        
        
        //        APIWrapper.sharedInstance.LoginAndAnalysis()
        
        // Do any additional setup after loading the view.
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
