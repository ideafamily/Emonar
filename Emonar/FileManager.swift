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
    
    private var sharedAduioArray : [String] = []
    private var currentAudioIndex : Int!
    private let audioIndexKey = "AudioIndexKey"
    private var sharedEmotionDataArray: [EmotionData] = []
    private var currentEmotionDataIndex : Int = 0
    
    private let recordFileStorageKey = "recordFileStorageKey"
    private var sharedRecordFileArray: [RecordFile] = []
    private let recordFileIndexKey = "recordFileIndexKey"
    private var currentRecordIndex : Int!
    private var fileManager : NSFileManager!
    
    
    
    func getAudioIndex()->Int{
        if currentAudioIndex == nil {
            currentAudioIndex = userDefault.integerForKey(audioIndexKey)
        }
        return currentAudioIndex
    }
    

    
    func getNumberOfRecordFile()->Int {
        if currentRecordIndex == nil {
            currentRecordIndex = userDefault.integerForKey(recordFileIndexKey)
        }
        return currentRecordIndex

    }
    
    func insertAudioToStorage(filePath:String){
        var numberOfFile = getAudioIndex()
        sharedAduioArray.append(filePath)
        numberOfFile += 1
        setCurrentAudioIndex(numberOfFile)
    }
    
    func insertRecordFileToStorage(name:String,recordLength:String) {
        readRecordFileDictionaryFromStorage()
        let recordFile = RecordFile(name:name, audioArray: self.sharedAduioArray, emotionDataArray: self.sharedEmotionDataArray,recordLength:recordLength)
        
        var numberOfFile = getNumberOfRecordFile()
        self.sharedRecordFileArray.append(recordFile)
        numberOfFile += 1
        setCurrentRecordIndex(numberOfFile)
        syncRecordFileDictionaryToStorage()
        cleanupDataInMemory()
    }
    
    
    func insertEmotionDataToStorage(data:EmotionData){
        self.sharedEmotionDataArray.append(data)
    }
    
    func changeRecordFileName(index:Int, name: String){
        readRecordFileDictionaryFromStorage()
        let numberOfFile = getNumberOfRecordFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        let recordFile = sharedRecordFileArray[index]
        recordFile.name = name
        syncRecordFileDictionaryToStorage()
    }
    
    
    func deleteRecordFileFromStorage(index:Int){
        readRecordFileDictionaryFromStorage()
        var numberOfFile = getNumberOfRecordFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        let recordFile = sharedRecordFileArray[index]
        if fileManager == nil {
            fileManager = NSFileManager.defaultManager()
        }
        
        for recording in recordFile.sharedAduioArray {
            let actualPath = filePath(recording)
            do {
                try fileManager.removeItemAtPath(actualPath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
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
    
    private func cleanupDataInMemory(){
        self.sharedEmotionDataArray = []
        self.sharedAduioArray = []
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
    
    private func setCurrentRecordIndex(index:Int){
        self.currentRecordIndex = index
        userDefault.setInteger(index, forKey: recordFileIndexKey)
    }
    
    private func setCurrentAudioIndex(index:Int){
        self.currentAudioIndex = index
        userDefault.setInteger(index, forKey: audioIndexKey)
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
        print(self.sharedRecordFileArray.count)
        for elemnt in self.sharedRecordFileArray {
            print("record name:\(elemnt.name)")
            for emotion in elemnt.sharedEmotionDataArray {
                    print("emotion:\(emotion.emotion)")
            }
            for audio in elemnt.sharedAduioArray {
                    print("audio:\(audio)")
            }
            print("--------end---------")
        }
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedRecordFileArray), forKey: recordFileStorageKey)
    }
    
    
}
