//
//  FMUtils.swift
//  DouFM
//
//  Created by cissu on 2018/8/17.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa

class FMUtils: NSObject {
    
    @objc class func isDarkMode() -> Bool {
        if let model : String = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") {
            if model == "Dark" {
                return true
            }
        }
        return false
    }

}
