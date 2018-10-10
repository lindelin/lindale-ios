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
    
    static let controllerIdentifier = "Tasks"
    
    var myTaskCollection: MyTaskCollection? = MyTaskCollection.find()
    
    @IBOutlet weak var taskTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.updateUI()
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
        if OAuth.isLogined {
            self.setTitle("Loading...")
            DispatchQueue.main.async {
                MyTaskCollection.resources { (myTaskCollection) in
                    if let myTaskCollection = myTaskCollection {
                        self.myTaskCollection = myTaskCollection
                        self.updateUI()
                    }
                }
            }
        } else {
            presentController(withName: "Sync", context: nil)
        }
    }
    
    func updateUI() {
        if let myTaskCollection = self.myTaskCollection {
            self.taskTable.setNumberOfRows(myTaskCollection.tasks.count, withRowType: "DefaultTaskRow")
            for index in 0..<self.taskTable.numberOfRows {
                guard let row = self.taskTable.rowController(at: index) as? DefaultTaskRow else { continue }
                
                row.task = myTaskCollection.tasks[index]
            }
            self.setTitle("Tasks")
        } else {
            self.taskTable.setNumberOfRows(1, withRowType: "NoData")
            self.setTitle("Tasks")
        }
    }
}
