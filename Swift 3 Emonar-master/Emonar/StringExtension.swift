//
//  StringExtension.swift
//  Emonar
//
//  Created by Gelei Chen on 31/3/2016.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import Foundation
public extension String {
    
    public static func trimString(_ str: String) -> String {
        var new = ""
        for char in str.characters{
            if char == "," || char == "." { break }
            new.append(char)
        }
        return new
    }
    
    public static func addString(_ str: [String]) -> String {
        var new = ""
        for string in str{
            new = "\(new) \(string)"
        }
        return new        
    }
    
}
