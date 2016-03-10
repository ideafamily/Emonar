//
//  Analysis.swift
//  Emonar
//
//  Created by Gelei Chen on 8/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation
import MJExtension
class Analysis: NSObject {
    var result:Analysis_result!
    var status:String!
    var recordingId:String!
}
class Analysis_result:NSObject {
    var analysisSummary:Analysis_result_analysisSummary!
    var analysisSegments:NSArray!
    var duration:String!
    var sessionStatus:String!
}





