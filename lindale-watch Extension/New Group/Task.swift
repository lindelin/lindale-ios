//
//  Task.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/09/21.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

struct TaskResource {
    var tasks: [Task]
    
    init(tasks: [Dictionary<String, AnyObject>]) {
        var taskArray: [Task] = []
        for task in tasks {
            taskArray.append(Task(task: task))
        }
        self.tasks = taskArray
    }
    
    struct Task {
        var title: String
        var project: String
        var type: String
        var status: String
        var progress: String
        var color: UIColor
        
        init(task data: [String: Any]) {
            self.title = data["title"] as! String
            self.project = data["project"] as! String
            self.type = data["type"] as! String
            self.status = data["status"] as! String
            self.progress = (data["progress"] as! Int).description + "%"
            self.color = Colors.get(id: data["color"] as! Int)
        }
    }
    
    static func getFromPhone(handler: @escaping (TaskResource?) -> Void) {
        WatchSession.main.sendMessage(message: ["request": "tasks"]) { (reply: [String : Any]) in
            if let tasks = reply["tasks"] as? [Dictionary<String, AnyObject>] {
                handler(TaskResource(tasks: tasks))
            } else {
                handler(nil)
            }
        }
    }
}
