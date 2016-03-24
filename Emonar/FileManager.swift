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
    private var sharedDictionary : [Int:NSURL] = [:]
    
    func getCurrentFileIndex()->Int{
        return userDefault.integerForKey(fileIndexKey)
        
    }
    
    func getAllLocalFileStorage()->[Int:NSURL]?{
        readDictionaryFromStorage()
        return sharedDictionary
    }
    
    func insertFileToStorage(filePath:NSURL){
        readDictionaryFromStorage()
        var currentFileIndex = getCurrentFileIndex()
        sharedDictionary.updateValue(filePath, forKey: currentFileIndex)
        currentFileIndex += 1
        setCurrentFileIndex(currentFileIndex)
        syncDictionaryToStorage()
    }
    
    func deleteFileFromStorate(fileName:Int){
        readDictionaryFromStorage()
        sharedDictionary.removeValueForKey(fileName)
        syncDictionaryToStorage()
    }
    
    private func setCurrentFileIndex(index:Int){
        userDefault.setInteger(index, forKey: fileIndexKey)
    }
    
    private func readDictionaryFromStorage(){
        if sharedDictionary.count == 0 {
            if let data = userDefault.objectForKey(storageKey) as? NSData {
                self.sharedDictionary = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Int:NSURL])!
            }
        }
    }
    private func syncDictionaryToStorage(){
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedDictionary), forKey: storageKey)
        userDefault.synchronize()
    }
    
    
}
