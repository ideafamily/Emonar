//
//  FileManager.swift
//  Emonar
//
//  Created by Gelei Chen on 22/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation


private let _sharedInstance = FileManager()
public class FileManager: NSObject {
    class public var sharedInstance:FileManager {
        return _sharedInstance
    }
    private let userDefault = NSUserDefaults.standardUserDefaults()
    
    private let audioStorageKey = "audioStorageKey"
    private var sharedAduioArray : [String] = []
    private let audioIndexKey = "AudioIndexKey"
    private var currentAudioIndex : Int!
    
    private let emotionDataStorageKey = "emotionDataStorageKey"
    private var sharedEmotionDataArray: [EmonationData] = []
    private let emotionIndexKey = "emotionIndexKey"
    private var currentEmotionDataIndex : Int!
    
    private let recordFileStorageKey = "recordFileStorageKey"
    private var sharedRecordFileArray: [RecordFile] = []
    private let recordFileIndexKey = "recordFileIndexKey"
    private var currentRecordIndex : Int!
    
    
    
    
    func getNumberOfAudio()->Int{
        if currentAudioIndex == nil {
            currentAudioIndex = userDefault.integerForKey(audioIndexKey)
        }
        return currentAudioIndex
    }
    
    func getNumberOfEmotionData()->Int{
        if currentEmotionDataIndex == nil {
            currentEmotionDataIndex = userDefault.integerForKey(emotionIndexKey)
        }
        return currentEmotionDataIndex
    }
    
    func getNumberOfRecordFile()->Int {
        if currentRecordIndex == nil {
            currentRecordIndex = userDefault.integerForKey(recordFileIndexKey)
        }
        return currentRecordIndex

    }
    
    func insertAudioToStorage(filePath:String){
        readAudioDictionaryFromStorage()
        var numberOfFile = getNumberOfAudio()
        sharedAduioArray.append(filePath)
        numberOfFile += 1
        setCurrentAudioIndex(numberOfFile)
        syncAudioDictionaryToStorage()
    }
    
    func insertRecordFileToStorage(name:String) {
        readRecordFileDictionaryFromStorage()
        var startIndex = 0
        if self.sharedRecordFileArray.count != 0 {
            startIndex = self.sharedRecordFileArray[self.sharedRecordFileArray.count-1].endIndex+1
        }
        let recordFile = RecordFile(name:name, startIndex: startIndex, endIndex: getNumberOfAudio()-1)
        
        var numberOfFile = getNumberOfRecordFile()
        self.sharedRecordFileArray.append(recordFile)
        numberOfFile += 1
        setCurrentRecordIndex(numberOfFile)
        syncRecordFileDictionaryToStorage()
        
    }
    
    func insertEmotionDataToStorage(data:EmonationData){
        readEmotionDataDictionaryFromStorage()
        var numberOfFile = getNumberOfEmotionData()
        self.sharedEmotionDataArray.append(data)
        numberOfFile += 1
        setCurrentEmotionDataIndex(numberOfFile)
        syncEmotionDataDictionaryToStorage()
    }
    
    
    
    func deleteRecordFileFromStorage(index:Int){
        readRecordFileDictionaryFromStorage()
        var numberOfFile = getNumberOfRecordFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        sharedRecordFileArray.removeAtIndex(index)
        numberOfFile -= 1
        setCurrentRecordIndex(numberOfFile)
        syncRecordFileDictionaryToStorage()
    }
    
    
    func getAllLocalRecordFileFromStorage()->[RecordFile] {
        readRecordFileDictionaryFromStorage()
        return self.sharedRecordFileArray
    }
    
    func stringToURL(path:String)->NSURL{
        return NSURL.fileURLWithPath(filePath(path))
    }
    
    private func applicationDocumentsDirectory() -> String? {
        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if  paths.count > 0 {
            return paths[0] as? String
        }
        return nil
    }
    private func filePath(localPath:String)->String{
        return "\(applicationDocumentsDirectory()!)" + localPath
    }
    
    private func setCurrentAudioIndex(index:Int){
        self.currentAudioIndex = index
        userDefault.setInteger(index, forKey: audioIndexKey)
    }
    private func setCurrentEmotionDataIndex(index:Int){
        self.currentEmotionDataIndex = index
        userDefault.setInteger(index, forKey: emotionIndexKey)
    }
    private func setCurrentRecordIndex(index:Int){
        self.currentRecordIndex = index
        userDefault.setInteger(index, forKey: recordFileIndexKey)
    }
    
    
    private func readAudioDictionaryFromStorage(){
        if sharedAduioArray.count == 0 {
            if let data = userDefault.objectForKey(audioStorageKey) as? NSData {
                self.sharedAduioArray = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String])!
            }
        }
    }
    private func syncAudioDictionaryToStorage(){
        print("syncAudioDictionaryToStorage:\(self.sharedAduioArray)\n")
        for elemnt in self.sharedAduioArray {
            print(elemnt)
        }
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedAduioArray), forKey: audioStorageKey)
        userDefault.synchronize()
    }
    private func readEmotionDataDictionaryFromStorage(){
        if sharedEmotionDataArray.count == 0 {
            if let dataObject = userDefault.objectForKey(emotionDataStorageKey) as? NSData {
                self.sharedEmotionDataArray = (NSKeyedUnarchiver.unarchiveObjectWithData(dataObject) as? [EmonationData])!
            }
        }
    }
    private func syncEmotionDataDictionaryToStorage(){
        print("syncEmotionDataDictionaryToStorage:\(self.sharedEmotionDataArray)\n")
        for elemnt in self.sharedEmotionDataArray {
            print(elemnt.emotionDescription)
        }
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedEmotionDataArray), forKey: emotionDataStorageKey)
        userDefault.synchronize()
    }
    private func readRecordFileDictionaryFromStorage(){
        if sharedRecordFileArray.count == 0 {
            if let data = userDefault.objectForKey(recordFileStorageKey) as? NSData {
                self.sharedRecordFileArray = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [RecordFile])!
            }
        }
    }
    private func syncRecordFileDictionaryToStorage(){
        print("syncRecordFileDictionaryToStorage:\(self.sharedRecordFileArray)\n")
        for elemnt in self.sharedRecordFileArray {
            print(elemnt.startIndex)
            print(elemnt.endIndex)
        }
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedRecordFileArray), forKey: recordFileStorageKey)
        userDefault.synchronize()
    }
    
    
}
