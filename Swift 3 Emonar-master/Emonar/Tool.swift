//
//  Toll.swift
//  Flicks
//
//  Created by Gelei Chen on 9/1/2016.
//  Copyright © 2016 geleichen. All rights reserved.
//

import Foundation
import ProgressHUD
import SystemConfiguration
class Tool:NSObject
{
    
    
    static var twitterColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
    
    class func dismissHUD()
    {
        ProgressHUD.dismiss()
    }
    
    
    class func showProgressHUD(_ text:String)
    {
        ProgressHUD.show(text)
    }
    
    class func showSuccessHUD(_ text:String)
    {
        ProgressHUD.showSuccess(text)
    }
    
    class func showErrorHUD(_ text:String)
    {
        ProgressHUD.showError(text)
    }
    
    class func stringFromTimeInterval(_ interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

