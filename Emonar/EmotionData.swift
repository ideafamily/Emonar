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
    var startTime:Date?
    init (emotion:String,emotionDescription:String,analyzed:Bool,startTime:Date?) {
        self.emotion = emotion
        self.emotionDescription = emotionDescription
        self.analyzed = analyzed
        self.startTime = startTime
    }
    required init?(coder aDecoder: NSCoder) {
        self.emotion = aDecoder.decodeObject(forKey: "emotion") as! String
        self.emotionDescription = aDecoder.decodeObject(forKey: "emotionDescription") as! String
        //self.analyzed = aDecoder.decodeObject(forKey: "analyzed") as! Bool
        if let time = aDecoder.decodeObject(forKey: "startTime") as? Date {
            self.startTime = time
        }
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.emotion, forKey: "emotion")
        aCoder.encode(self.emotionDescription, forKey: "emotionDescription")
        aCoder.encode(self.analyzed, forKey: "analyzed")
        if self.startTime != nil {
           aCoder.encode(self.startTime, forKey: "startTime")
        }
        
    }
}

