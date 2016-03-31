//
//  MainViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/10/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func gotoRecord(sender: AnyObject) {
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    @IBAction func gotoArchive(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoArchive", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        APIWrapper.sharedInstance.LoginAndAnalysis()
//        FileManager.sharedInstance.insertFileToStorage(NSURL(string: "1")!)
//        if let dict = FileManager.sharedInstance.getAllLocalFileStorage() {
//            print(dict)
//        }
//        FileManager.sharedInstance.deleteFileFromStorate(FileManager.sharedInstance.getNumberOfFile()-1)
//        if let dict = FileManager.sharedInstance.getAllLocalFileStorage() {
//            print(dict)
//        }
//        FileManager.sharedInstance.insertFileToStorage(NSURL(string: "2")!)
//        FileManager.sharedInstance.insertFileToStorage(NSURL(string: "3")!)
//        FileManager.sharedInstance.deleteFileFromStorate(FileManager.sharedInstance.getNumberOfFile())
//        if let dict = FileManager.sharedInstance.getAllLocalFileStorage() {
//            print(dict)
//        }
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
