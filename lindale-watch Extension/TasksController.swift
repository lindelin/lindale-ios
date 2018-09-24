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
        self.loadData()
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
        self.loadData()
    }
    
    func loadData() {
        TaskResource.getFromPhone { (taskResource) in
            if let taskResource = taskResource {
                self.updateUI(with: taskResource)
            }
        }
    }
    
    func updateUI(with taskResource: TaskResource) {
        self.taskTable.setNumberOfRows(taskResource.tasks.count, withRowType: "DefaultTaskRow")
        for index in 0..<self.taskTable.numberOfRows {
            guard let row = self.taskTable.rowController(at: index) as? DefaultTaskRow else { continue }
            
            row.task = taskResource.tasks[index]
        }
    }
}
