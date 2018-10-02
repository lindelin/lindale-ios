//
//  NSUserActivity+IntentData.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/28.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation
import MobileCoreServices

extension NSUserActivity {
    
    public static let hasTaskActivityType = "org.lindelin.lindale.hasTask"
    public static let hasTodoActivityType = "org.lindelin.lindale.hasTodo"
    
    public static var hasTaskActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: NSUserActivity.hasTaskActivityType)
        
        // User activites should be as rich as possible, with icons and localized strings for appropiate content attributes.
        userActivity.title = "Important Task"
        userActivity.isEligibleForPrediction = true
        
        let phrase = "Prompt for important tasks"
        userActivity.suggestedInvocationPhrase = phrase
        return userActivity
    }
    
    public static var hasTodoActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: NSUserActivity.hasTodoActivityType)
        
        // User activites should be as rich as possible, with icons and localized strings for appropiate content attributes.
        userActivity.title = "Important TODO"
        userActivity.isEligibleForPrediction = true
        
        let phrase = "Prompt for important TODOs"
        userActivity.suggestedInvocationPhrase = phrase
        return userActivity
    }
}
