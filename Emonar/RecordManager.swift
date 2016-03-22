//
//  RecordManager.swift
//  Emonar
//
//  Created by Carl Chen on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class RecordManager: NSObject, EZMicrophoneDelegate, EZAudioPlayerDelegate, EZRecorderDelegate {
    
    var microphone: EZMicrophone?
    var player: EZAudioPlayer?
    var recorder: EZRecorder!
    var isRecording: Bool
    var directory: NSURL!
    
    static private var shareInstance: RecordManager?
    
    class func sharedInstance() -> RecordManager {
        if shareInstance == nil {
            shareInstance = RecordManager()
        }
        return shareInstance!
    }
    
    override init() {
        isRecording = false
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        
        self.microphone = EZMicrophone(delegate: self)
        self.player = EZAudioPlayer(delegate: self)
        
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        
    }
    
    func recordNewAudio() {
        
        let fileManager = NSFileManager.defaultManager()
        
        directory = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: .None, create: true)
        directory = NSURL(string: directory.absoluteString + "Recordings/")!
        
        try! fileManager.createDirectoryAtURL(directory, withIntermediateDirectories: true, attributes: nil)
        
        let fileName = "audio1.m4a"
        
        directory = NSURL(string: directory.absoluteString + fileName)!
        
        
        
        //print(directory)
        //print(audioURL)
        microphone?.startFetchingAudio()
        recorder = EZRecorder(URL: directory, clientFormat: microphone!.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)
        //recorder = EZRecorder(URL: directory, clientFormat: microphone!.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A)
        
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if isRecording {
            recorder.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
    }
    
    func stopRecording() {
        recorder.closeAudioFile()
        microphone?.stopFetchingAudio()
        //print("s")
    }
    
    func stopPlaying() {
        self.player?.pause()
    }
    
    func startPlay() {
        
        
        var d = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: .None, create: true)
        d = NSURL(string: d.absoluteString + "Recordings/")!
        let contents = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(d, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles)
        for content in contents {
            let audioFile = EZAudioFile(URL: content)
            self.player?.playAudioFile(audioFile)
        }
        
        
        
    }
    
    
}
