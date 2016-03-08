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
    var Arousal:Analysis_result_analysisSegments_analysis_ArousalAndTemper!
    var AudioQuality:Analysis_result_analysisSegments_analysis_Arousal_AudioQuality!
    var Gender:Analysis_result_analysisSegments_analysis_Arousal_Gender!
    var Mood:Analysis_result_analysisSegments_analysis_Arousal_Mood!
    var Temper:Analysis_result_analysisSegments_analysis_ArousalAndTemper!
    var Valence:Analysis_result_analysisSegments_analysis_ArousalAndTemper!
}
class Analysis_result_analysisSegments_analysis_ArousalAndTemper : NSObject {
    var Group:String!
    var Summary:analysisModel!
    var Value:String!
}
class Analysis_result_analysisSegments_analysis_Arousal_AudioQuality : NSObject {
    var Value : String!
}
class Analysis_result_analysisSegments_analysis_Arousal_Gender : NSObject {
    var Group : String!
}
class Analysis_result_analysisSegments_analysis_Arousal_Mood : NSObject {
    var Composite : Analysis_result_analysisSegments_analysis_Arousal_Mood_PrimaryAndGroup11!
    var Group11 : Analysis_result_analysisSegments_analysis_Arousal_Mood_PrimaryAndGroup11!
}
class Analysis_result_analysisSegments_analysis_Arousal_Mood_PrimaryAndGroup11 : NSObject {
    var Primary : Analysis_result_analysisSegments_analysis_Arousal_Mood_Primary_Model!
    var Secondary : Analysis_result_analysisSegments_analysis_Arousal_Mood_Primary_Model!
}
class  Analysis_result_analysisSegments_analysis_Arousal_Mood_Primary_Model : NSObject {
    var Id : NSNumber!
    var Phrase : String!
}


