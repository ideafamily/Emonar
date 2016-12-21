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
        self.currentDate = Date().shortDate
        self.recordLength = recordLength
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.sharedAduioArray = aDecoder.decodeObject(forKey: "sharedAduioArray") as! [String]
        self.sharedEmotionDataArray = aDecoder.decodeObject(forKey: "sharedEmotionDataArray") as! [EmotionData]
        self.currentDate = aDecoder.decodeObject(forKey: "currentDate") as! String
        self.recordLength = aDecoder.decodeObject(forKey: "recordLength") as! String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.sharedAduioArray, forKey: "sharedAduioArray")
        aCoder.encode(self.sharedEmotionDataArray, forKey: "sharedEmotionDataArray")
        aCoder.encode(self.currentDate, forKey: "currentDate")
        aCoder.encode(self.recordLength, forKey: "recordLength")
    }
    func audioArrayToNSURLArray()->[URL]{
        var result:[URL] = []
        for string in self.sharedAduioArray {
            result.append(FileManager.sharedInstance.stringToURL(string))
        }
        return result
    }
}
