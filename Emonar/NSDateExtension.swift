//
//  NSDateExtension.swift
//  Emonar
//
//  Created by Gelei Chen on 7/4/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation
extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

extension NSDate {
    struct Date {
        static let formatterShortDate = NSDateFormatter(dateFormat: "yyyy-MM-dd")
    }
    var shortDate: String {
        return Date.formatterShortDate.stringFromDate(self)
    }
}