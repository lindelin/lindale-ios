//
//  Models.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/30.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation
import UIKit
import Intents

struct TaskShortcut {
    var id: Int
    var title: String
    var status: String
    var startAt: String?
    var endAt: String?
    
    init(id: Int, title: String, status: String, startAt: String?, endAt: String?) {
        self.id = id
        self.title = title
        self.status = status
        self.startAt = startAt
        self.endAt = endAt
    }
    
    public var intent: TaskIntent {
        let taskIntent = TaskIntent()
        taskIntent.title = self.title
        taskIntent.status = self.status
        taskIntent.setImage(INImage(named: "task-30"), forParameterNamed: \TaskIntent.title)
        return taskIntent
    }
    
    public var userActivity: NSUserActivity {
        let userActivity = NSUserActivity.hasTaskActivity
        return userActivity
    }
}
