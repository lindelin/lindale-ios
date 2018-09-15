//
//  UITheme.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/09/09.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class Colors {
    static let themeBase = UIColor(named: "Theme-base")!
    static let themeBaseSub = UIColor(named: "Theme-base-sub")!
    static let themeBaseOptional = UIColor(named: "Theme-base-optional")!
    static let themeMain = UIColor(named: "Theme-main")!
    static let themeMainOptional = UIColor(named: "Theme-main-optional")!
    static let themeSub = UIColor(named: "Theme-sub")!
    static let themeBlue = UIColor(named: "Theme-blue")!
    static let themeYellow = UIColor(named: "Theme-yellow")!
    static let themeGreen = UIColor(named: "Theme-green")!
    static let themeBackground = UIColor(named: "Theme-background")!
    
    static func get(id: Int) -> UIColor {
        switch id {
        case 1:
            return self.themeBaseOptional  
        case 2:
            return self.themeBase
        case 3:
            return self.themeGreen
        case 4:
            return self.themeBlue
        case 5:
            return self.themeYellow
        case 6:
            return self.themeMain
        default:
            return self.themeBase
        }
    }
}