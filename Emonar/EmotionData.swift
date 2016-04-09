//
//  EmotionData.swift
//  Emonar
//
//  Created by Carl Chen on 4/7/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation

class EmonationData : NSObject,NSCoding {
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

class RecordFile : NSObject,NSCoding {
    var name:String = "123"
    var startIndex:Int  = 1
    var endIndex:Int = 2
    var currentDate:String!
    var recordLength:String!
    init(name:String,startIndex:Int,endIndex:Int,recordLength:String){
        self.name = name
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.currentDate = NSDate().shortDate
        self.recordLength = recordLength
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.startIndex = aDecoder.decodeObjectForKey("startIndex") as! Int
        self.endIndex = aDecoder.decodeObjectForKey("endIndex") as! Int
        self.currentDate = aDecoder.decodeObjectForKey("currentDate") as! String
        self.recordLength = aDecoder.decodeObjectForKey("recordLength") as! String
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.startIndex, forKey: "startIndex")
        aCoder.encodeObject(self.endIndex, forKey: "endIndex")
        aCoder.encodeObject(self.currentDate, forKey: "currentDate")
        aCoder.encodeObject(self.recordLength, forKey: "recordLength")
    }
}