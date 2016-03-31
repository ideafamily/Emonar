//
//  APIWrapper.swift
//  Emonar
//
//  Created by Gelei Chen on 3/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation

private let _sharedInstance = APIWrapper()

final public class APIWrapper : NSObject{
    
    var fileBeingSent = false
    
    class public var sharedInstance:APIWrapper {
        return _sharedInstance
        
    }
    func hasLoggedin()->Bool{
        return ApiManager.sharedManager().accessToken == nil
    }
    
    func LoginAndAnalysis(){
        // 1. Call getAccessToken
        ApiManager.sharedManager().getAccessTokenSuccess { (data:NSData!) -> Void in
            // When successful:
            // 2. Call startSession
            ApiManager.sharedManager().startSessionSuccess({ (data:NSData!) -> Void in
                // When successful:
                // BOOL fileBeingSent is used to stop sending Analysis requests after send file is finished
                self.fileBeingSent = true
                
                // 3. Call sendAudioFile with sample.wav
                ApiManager.sharedManager().sendAudioFile("sample", fileType: "wav", success: { (response:[NSObject : AnyObject]!) -> Void in
                    self.fileBeingSent = false
                    print(response)
                    let analysis = Analysis.mj_objectWithKeyValues(response)
//                    print(analysis.result.analysisSummary.AnalysisResult.Arousal.Mean)
                    let analysisArray = analysis.result.analysisSegments
                    for element in analysisArray {
                        let elementObject = Analysis_result_analysisSegments.mj_objectWithKeyValues(element)
//                        print(elementObject.analysis.Arousal.Value)
                    }
                })
                
                // 4. Call sendForAnalysis for the 1st time after 3 seconds
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.performSelector("sendForAnalysis", withObject: nil, afterDelay: 3)
//                })
                
            })
        }
    }
    func sendForAnalysis() {
        if fileBeingSent == true {
            NSLog("getAnalysis started")
            ApiManager.sharedManager().getAnalysisFromMs(0, success: { (data:NSData!) -> Void in
                do {
                    let responseDictionary: [NSObject : AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [NSObject : AnyObject]
                    NSLog("getAnalysis responseDictionary:\n%@", responseDictionary)
//                    let analysis = Analysis.mj_objectWithKeyValues(responseDictionary)
//                    print(analysis)
                    // Call sendForAnalysis after 1 second until send file is finished
                    if self.fileBeingSent == true {
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                            self.performSelector("sendForAnalysis", withObject: nil, afterDelay: 1)
                        })
                    }
                } catch{
                    
                }
            })
        }
    }
}