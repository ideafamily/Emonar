//
//  Toll.swift
//  Flicks
//
//  Created by Gelei Chen on 9/1/2016.
//  Copyright © 2016 geleichen. All rights reserved.
//

import Foundation
import ProgressHUD
class Tool:NSObject
{
    
    
    static var twitterColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
    
    class func dismissHUD()
    {
        ProgressHUD.dismiss()
    }
    
    
    class func showProgressHUD(text:String)
    {
        ProgressHUD.show(text)
    }
    
    class func showSuccessHUD(text:String)
    {
        ProgressHUD.showSuccess(text)
    }
    
    class func showErrorHUD(text:String)
    {
        ProgressHUD.showError(text)
    }
    
    
    
    
    
    
}