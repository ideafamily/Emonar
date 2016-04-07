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
    private var sharedArray : [String] = []
    
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
    
    
    
    func getAllLocalFileStorage()->[NSURL]? {
        readDictionaryFromStorage()
        
        var files : [NSURL] = []
        for localPath in sharedArray {
            files.append(NSURL.fileURLWithPath(filePath(localPath)))
        }
        return files
    }
    
    func insertFileToStorage(filePath:String){
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
                self.sharedArray = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String])!
            }
        }
    }
    private func syncDictionaryToStorage(){

//        print("about to sync \(self.sharedArray)")
        userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.sharedArray), forKey: storageKey)
        userDefault.synchronize()
    }
    
    
}
