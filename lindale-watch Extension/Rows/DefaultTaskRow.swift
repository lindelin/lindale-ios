//
//  DefaultTaskRow.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/09/19.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import WatchKit

class DefaultTaskRow: NSObject {
    
    @IBOutlet weak var color: WKInterfaceSeparator!
    @IBOutlet weak var type: WKInterfaceLabel!
    @IBOutlet weak var projectName: WKInterfaceLabel!
    @IBOutlet weak var taskTitle: WKInterfaceLabel!
    @IBOutlet weak var progress: WKInterfaceLabel!
    @IBOutlet weak var status: WKInterfaceLabel!
    
    var task:MyTaskCollection.Task? {
        didSet {
            guard let task = task else { return }
            
            self.color.setColor(Colors.get(id: task.color))
            self.type.setText(task.type)
            self.projectName.setText(task.projectName)
            self.taskTitle.setText(task.title)
            self.progress.setText(task.progress.description)
            self.status.setText(task.status)
        }
    }
}
