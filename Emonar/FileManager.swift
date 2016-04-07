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
    private let audioStorageKey = "AudioIO"
    private let fileIndexKey = "CurrentFileIndex"
    private let emotionDataStorageKey = "EmotionData"
    private let recordFileStorageKey = "RecordFileStorage"
    private var sharedArray : [String] = []
    private var sharedEmotionData: [data] = []
    private var sharedRecordFiles: [RecordFile] = []
    private var startIndex = 0;
    
    func getNumberOfFile()->Int{
        return userDefault.integerForKey(fileIndexKey)
        
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
    
    func insertRecordFile(name:String) {
        let recordFile = RecordFile(name:name, startIndex: startIndex, endIndex: getNumberOfFile()-1)
        
        
        
        
    }
    
    func insertEmotionDataToStorage(da:data){
        
    }
    func deleteRecordFileFromStorage(index:Int){
        
    }
    
    
    func getAllLocalFileStorage()->[NSURL]? {
        readAudioDictionaryFromStorage()
        
        var files : [NSURL] = []
        for localPath in sharedArray {
            files.append(NSURL.fileURLWithPath(filePath(localPath)))
        }
        return files
    }
    
    
    func insertFileToStorage(filePath:String){
        readAudioDictionaryFromStorage()
        var numberOfFile = getNumberOfFile()
        sharedArray.append(filePath)
        numberOfFile += 1
        setCurrentFileIndex(numberOfFile)
        
        syncAudioDictionaryToStorage()
    }
    
    func deleteFileFromStorate(index:Int){
        readAudioDictionaryFromStorage()
        
        
        var numberOfFile = getNumberOfFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        sharedArray.removeAtIndex(index)
        numberOfFile -= 1
        setCurrentFileIndex(numberOfFile)
        syncAudioDictionaryToStorage()
    }
    
    private func setCurrentFileIndex(index:Int){
        userDefault.setInteger(index, forKey: fileIndexKey)
    }
    
    private func readAudioDictionaryFromStorage(){
        if sharedArray.count == 0 {
            if let data = userDefault.objectForKey(audioStorageKey) as? NSData {
                self.sharedArray = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String])!
            }
        }
    }
    private func syncAudioDictionaryToStorage(){

//        print("about to sync \(self.sharedArray)")
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedArray), forKey: audioStorageKey)
        userDefault.synchronize()
    }
    private func readEmotionDataDictionaryFromStorage(){
        if sharedEmotionData.count == 0 {
            if let dataObject = userDefault.objectForKey(emotionDataStorageKey) as? NSData {
                self.sharedEmotionData = (NSKeyedUnarchiver.unarchiveObjectWithData(dataObject) as? [data])!
            }
        }
    }
    private func syncEmotionDataDictionaryToStorage(){
        
        //        print("about to sync \(self.sharedArray)")
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedEmotionData), forKey: emotionDataStorageKey)
        userDefault.synchronize()
    }
    private func readRecordFileDictionaryFromStorage(){
        if sharedRecordFiles.count == 0 {
            if let data = userDefault.objectForKey(recordFileStorageKey) as? NSData {
                self.sharedRecordFiles = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [RecordFile])!
            }
        }
    }
    private func syncRecordFileDictionaryToStorage(){
        
        //        print("about to sync \(self.sharedArray)")
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedRecordFiles), forKey: recordFileStorageKey)
        userDefault.synchronize()
    }
    
    
}
