//
//  Analysis_result_analysisSummary.swift
//  Emonar
//
//  Created by Gelei Chen on 8/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation
import MJExtension
class Analysis_result_analysisSummary:NSObject {
    var AnalysisResult:Analysis_result_analysisSummary_AnalysisResult!
}
class Analysis_result_analysisSummary_AnalysisResult:NSObject{
    var Arousal:analysisModel!
    var Temper:analysisModel!
    var Valence:analysisModel!
}

class analysisModel : NSObject {
    var Mean:String!
    var Mode:String!
    var ModePct:NSNumber!
}
