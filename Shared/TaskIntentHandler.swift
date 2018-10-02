//
//  TaskIntentHandler.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/30.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

public class TaskIntentHandler: NSObject, TaskIntentHandling {
    
    public func handle(intent: TaskIntent, completion: @escaping (TaskIntentResponse) -> Void) {
        let response = TaskIntentResponse()
        let userActivity = NSUserActivity.hasTaskActivity
        response.userActivity = userActivity
        completion(response)
    }
    
}
