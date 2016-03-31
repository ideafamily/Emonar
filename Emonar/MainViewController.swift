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

    @IBAction func gotoRecord(sender: AnyObject) {
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    @IBAction func gotoArchive(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoArchive", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !APIWrapper.sharedInstance.hasLoggedin() {
            ProgressHUD.
            APIWrapper.sharedInstance.loginWithCallback({ 
                
            })
        }
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
