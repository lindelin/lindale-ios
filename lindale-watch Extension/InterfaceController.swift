//
//  InterfaceController.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/09/13.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var projectTable: WKInterfaceTable!
    
    var projects: [[String: Any]] = []

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        WatchSession.main.sendMessage(key: "aaa", value: "bbb") { (reply: [String : Any]) in
            let projects = reply["projects"] as! [Dictionary<String, AnyObject>]
            self.projects = projects
            let totalnum = projects.count
            self.projectTable.setNumberOfRows(totalnum, withRowType: "ProjectRow")
            for index in 0..<totalnum {
                let row = self.projectTable.rowController(at: index) as! ProjectRow
                row.projectTitle.setText((projects[index]["title"] as! String))
            }
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

}
