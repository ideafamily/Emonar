//
//  EmotionData.swift
//  Emonar
//
//  Created by Carl Chen on 4/7/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation

class EmotionData : NSObject,NSCoding {
    var emotion = "Analyzing"
    var emotionDescription = "Sorry,Emonar doesn't understand your current emotion.Maybe input voice is too low."
    var analyzed = false
    var startTime:NSDate?
    init (emotion:String,emotionDescription:String,analyzed:Bool,startTime:NSDate?) {
        self.emotion = emotion
        self.emotionDescription = emotionDescription
        self.analyzed = analyzed
        self.startTime = startTime
    }
    required init?(coder aDecoder: NSCoder) {
        self.emotion = aDecoder.decodeObjectForKey("emotion") as! String
        self.emotionDescription = aDecoder.decodeObjectForKey("emotionDescription") as! String
        self.analyzed = aDecoder.decodeObjectForKey("analyzed") as! Bool
        if let time = aDecoder.decodeObjectForKey("startTime") as? NSDate {
            self.startTime = time
        }
        
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.emotion, forKey: "emotion")
        aCoder.encodeObject(self.emotionDescription, forKey: "emotionDescription")
        aCoder.encodeObject(self.analyzed, forKey: "analyzed")
        if self.startTime != nil {
           aCoder.encodeObject(self.startTime, forKey: "startTime")
        }
        
    }
}

