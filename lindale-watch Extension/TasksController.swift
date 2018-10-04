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
        if OAuth.isLogined {
            self.loadData()
        } else {
            presentController(withNames: ["Test"], contexts: nil)
            popToRootController()
        }
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
        MyTaskCollection.resources { (myTaskCollection) in
            if let myTaskCollection = myTaskCollection {
                self.myTaskCollection = myTaskCollection
                self.updateUI(with: myTaskCollection)
            }
        }
    }
    
    func updateUI(with myTaskCollection: MyTaskCollection) {
        self.taskTable.setNumberOfRows(myTaskCollection.tasks.count, withRowType: "DefaultTaskRow")
        for index in 0..<self.taskTable.numberOfRows {
            guard let row = self.taskTable.rowController(at: index) as? DefaultTaskRow else { continue }
            
            row.task = myTaskCollection.tasks[index]
        }
    }
}
