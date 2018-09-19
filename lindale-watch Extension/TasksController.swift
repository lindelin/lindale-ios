//
//  TasksController.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/09/19.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import WatchKit
import Foundation


class TasksController: WKInterfaceController {
    
    @IBOutlet weak var taskTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        WatchSession.main.startSession()
        self.update()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func refresh() {
        self.update()
    }
    
    func update() {
        WatchSession.main.sendMessage(message: ["request": "tasks"]) { (reply: [String : Any]) in
            if let tasks = reply["tasks"] as? [Dictionary<String, AnyObject>] {
                OperationQueue.main.addOperation {
                    let totalnum = tasks.count
                    self.taskTable.setNumberOfRows(totalnum, withRowType: "DefaultTaskRow")
                    for index in 0..<totalnum {
                        let row = self.taskTable.rowController(at: index) as! DefaultTaskRow
                        row.setRow(tasks[index])
                    }
                }
            }
            
        }
    }
}
