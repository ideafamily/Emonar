//
//  Analysis_result_analysisSegments.swift
//  Emonar
//
//  Created by Gelei Chen on 8/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation
import MJExtension
class Analysis_result_analysisSegments:NSObject {
    var analysis:Analysis_result_analysisSegments_analysis!
    var duration:NSNumber!
    var offset:NSNumber!
}
class Analysis_result_analysisSegments_analysis : NSObject{
    var Arousal:NSDictionary!
    var AudioQuality:NSDictionary!
    var Gender:NSDictionary!
    var Mood:NSDictionary!
    var Temper:NSDictionary!
    var Valence:NSDictionary!
}
