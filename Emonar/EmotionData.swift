//
//  EmotionData.swift
//  Emonar
//
//  Created by Carl Chen on 4/7/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation

class data : AnyObject {
    var emotion = "Analyzing"
    var description = "Sorry,Emonar doesn't understand your current emotion.Maybe input voice is too low."
    var analyzed = false
    var startTime:NSDate?
    init (emotion:String,description:String,analyzed:Bool,startTime:NSDate?) {
        self.emotion = emotion
        self.description = description
        self.analyzed = analyzed
        self.startTime = startTime
    }
}

class RecordFile : AnyObject {
    var name:String = "123"
    var startIndex:Int  = 1
    var endIndex:Int = 2
    init(name:String,startIndex:Int,endIndex:Int){
        self.name = name
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
}