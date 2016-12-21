//
//  FileManager.swift
//  Emonar
//
//  Created by Gelei Chen on 22/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation


private let _sharedInstance = FileManager()
open class FileManager: NSObject {
    class open var sharedInstance:FileManager {
        return _sharedInstance
    }
    fileprivate let userDefault = UserDefaults.standard
    
    fileprivate var sharedAduioArray : [String] = []
    fileprivate var currentAudioIndex : Int!
    fileprivate let audioIndexKey = "AudioIndexKey"
    fileprivate var sharedEmotionDataArray: [EmotionData] = []
    fileprivate var currentEmotionDataIndex : Int = 0
    
    fileprivate let recordFileStorageKey = "recordFileStorageKey"
    fileprivate var sharedRecordFileArray: [RecordFile] = []
    fileprivate let recordFileIndexKey = "recordFileIndexKey"
    fileprivate var currentRecordIndex : Int!
    fileprivate var fileManager : Foundation.FileManager!
    
    
    
    func getAudioIndex()->Int{
        if currentAudioIndex == nil {
            currentAudioIndex = userDefault.integer(forKey: audioIndexKey)
        }
        return currentAudioIndex
    }
    

    
    func getNumberOfRecordFile()->Int {
        if currentRecordIndex == nil {
            currentRecordIndex = userDefault.integer(forKey: recordFileIndexKey)
        }
        return currentRecordIndex

    }
    
    func insertAudioToStorage(_ filePath:String){
        var numberOfFile = getAudioIndex()
        sharedAduioArray.append(filePath)
        numberOfFile += 1
        setCurrentAudioIndex(numberOfFile)
    }
    
    func insertRecordFileToStorage(_ name:String,recordLength:String) {
        readRecordFileDictionaryFromStorage()
        let recordFile = RecordFile(name:name, audioArray: self.sharedAduioArray, emotionDataArray: self.sharedEmotionDataArray,recordLength:recordLength)
        
        var numberOfFile = getNumberOfRecordFile()
        self.sharedRecordFileArray.append(recordFile)
        numberOfFile += 1
        setCurrentRecordIndex(numberOfFile)
        syncRecordFileDictionaryToStorage()
        cleanupDataInMemory()
    }
    
    
    func insertEmotionDataToStorage(_ data:EmotionData){
        self.sharedEmotionDataArray.append(data)
    }
    
    func changeRecordFileName(_ index:Int, name: String){
        readRecordFileDictionaryFromStorage()
        let numberOfFile = getNumberOfRecordFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        let recordFile = sharedRecordFileArray[index]
        recordFile.name = name
        syncRecordFileDictionaryToStorage()
    }
    
    
    func deleteRecordFileFromStorage(_ index:Int){
        readRecordFileDictionaryFromStorage()
        var numberOfFile = getNumberOfRecordFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        let recordFile = sharedRecordFileArray[index]
        if fileManager == nil {
            fileManager = Foundation.FileManager.default
        }
        
        for recording in recordFile.sharedAduioArray {
            let actualPath = filePath(recording)
            do {
                try fileManager.removeItem(atPath: actualPath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        sharedRecordFileArray.remove(at: index)
        numberOfFile -= 1
        setCurrentRecordIndex(numberOfFile)
        syncRecordFileDictionaryToStorage()
    }
    
    
    func getAllLocalRecordFileFromStorage()->[RecordFile] {
        readRecordFileDictionaryFromStorage()
        return self.sharedRecordFileArray
    }
    
    func stringToURL(_ path:String)->URL{
        return URL(fileURLWithPath: filePath(path))
    }
    
    fileprivate func cleanupDataInMemory(){
        self.sharedEmotionDataArray = []
        self.sharedAduioArray = []
    }
    
    fileprivate func applicationDocumentsDirectory() -> String? {
        let paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true) as [AnyObject]
        if  paths.count > 0 {
            return paths[0] as? String
        }
        return nil
    }
    fileprivate func filePath(_ localPath:String)->String{
        return "\(applicationDocumentsDirectory()!)" + localPath
    }
    
    fileprivate func setCurrentRecordIndex(_ index:Int){
        self.currentRecordIndex = index
        userDefault.set(index, forKey: recordFileIndexKey)
    }
    
    fileprivate func setCurrentAudioIndex(_ index:Int){
        self.currentAudioIndex = index
        userDefault.set(index, forKey: audioIndexKey)
    }
    
    fileprivate func readRecordFileDictionaryFromStorage(){
        if sharedRecordFileArray.count == 0 {
            if let data = userDefault.object(forKey: recordFileStorageKey) as? Data {
                self.sharedRecordFileArray = (NSKeyedUnarchiver.unarchiveObject(with: data) as? [RecordFile])!
            }
        }
    }
    fileprivate func syncRecordFileDictionaryToStorage(){
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
        userDefault.set(NSKeyedArchiver.archivedData(withRootObject: self.sharedRecordFileArray), forKey: recordFileStorageKey)
    }
    
    
}
