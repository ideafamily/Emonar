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
    private let storageKey = "AudioIO"
    private let fileIndexKey = "CurrentFileIndex"
    private var sharedArray : [NSURL] = []
    
    func getNumberOfFile()->Int{
        return userDefault.integerForKey(fileIndexKey)
        
    }
    
    func getAllLocalFileStorage()->[NSURL]?{
        readDictionaryFromStorage()
        return sharedArray
    }
    
    func insertFileToStorage(filePath:NSURL){
        readDictionaryFromStorage()
        var numberOfFile = getNumberOfFile()
        sharedArray.append(filePath)
        numberOfFile += 1
        setCurrentFileIndex(numberOfFile)
        syncDictionaryToStorage()
    }
    
    func deleteFileFromStorate(index:Int){
        readDictionaryFromStorage()
        
        
        var numberOfFile = getNumberOfFile()
        if index >= numberOfFile || index < 0 {
            return
        }
        sharedArray.removeAtIndex(index)
        numberOfFile -= 1
        setCurrentFileIndex(numberOfFile)
        syncDictionaryToStorage()
    }
    
    private func setCurrentFileIndex(index:Int){
        userDefault.setInteger(index, forKey: fileIndexKey)
    }
    
    private func readDictionaryFromStorage(){
        if sharedArray.count == 0 {
            if let data = userDefault.objectForKey(storageKey) as? NSData {
                self.sharedArray = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [NSURL])!
            }
        }
    }
    private func syncDictionaryToStorage(){

        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedArray), forKey: storageKey)
        userDefault.synchronize()
    }
    
    
}
