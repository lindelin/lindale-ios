//
//  TodosController.swift
//  lindale-watch Extension
//
//  Created by LINDALE on 2018/10/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import WatchKit
import Foundation


class TodosController: WKInterfaceController {
    
    static let controllerIdentifier = "Todos"
    
    var myTodoCollection: MyTodoCollection? = MyTodoCollection.find()

    @IBOutlet weak var todoTable: WKInterfaceTable!
    
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
                MyTodoCollection.resources { (myTodoCollection) in
                    if let myTodoCollection = myTodoCollection {
                        self.myTodoCollection = myTodoCollection
                        self.updateUI()
                    }
                }
            }
        } else {
            presentController(withName: "Sync", context: nil)
        }
    }
    
    func updateUI() {
        if let myTodoCollection = self.myTodoCollection {
            self.todoTable.setNumberOfRows(myTodoCollection.todos.count, withRowType: "DefaultTodoRow")
            for index in 0..<self.todoTable.numberOfRows {
                guard let row = self.todoTable.rowController(at: index) as? DefaultTodoRow else { continue }
                
                row.todo = myTodoCollection.todos[index]
            }
            self.setTitle("TODOs")
        } else {
            self.todoTable.setNumberOfRows(1, withRowType: "NoData")
            self.setTitle("TODOs")
        }
    }

}
