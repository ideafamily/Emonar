//
//  RecordFile.swift
//  Emonar
//
//  Created by Gelei Chen on 9/4/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation

class RecordFile : NSObject,NSCoding {
    var name:String = "123"
    var sharedAduioArray : [String] = []
    var sharedEmotionDataArray: [EmotionData] = []
    var currentDate:String!
    var recordLength:String!
    init(name:String,audioArray:[String],emotionDataArray:[EmotionData],recordLength:String){
        self.name = name
        self.sharedAduioArray = audioArray
        self.sharedEmotionDataArray = emotionDataArray
        self.currentDate = NSDate().shortDate
        self.recordLength = recordLength
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.sharedAduioArray = aDecoder.decodeObjectForKey("sharedAduioArray") as! [String]
        self.sharedEmotionDataArray = aDecoder.decodeObjectForKey("sharedEmotionDataArray") as! [EmotionData]
        self.currentDate = aDecoder.decodeObjectForKey("currentDate") as! String
        self.recordLength = aDecoder.decodeObjectForKey("recordLength") as! String
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.sharedAduioArray, forKey: "sharedAduioArray")
        aCoder.encodeObject(self.sharedEmotionDataArray, forKey: "sharedEmotionDataArray")
        aCoder.encodeObject(self.currentDate, forKey: "currentDate")
        aCoder.encodeObject(self.recordLength, forKey: "recordLength")
    }
}