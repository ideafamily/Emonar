//
//  ViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/1/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIWrapper.sharedInstance.LoginAndAnalysis()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

