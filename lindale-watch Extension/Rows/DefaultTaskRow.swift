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
    
    func setRow(_ data: [String: Any]) {
        print(data)
        self.color.setColor(Colors.get(id: data["color"] as! Int))
        self.type.setText(data["type"] as? String)
        self.projectName.setText(data["project"] as? String)
        self.taskTitle.setText(data["title"] as? String)
        self.progress.setText((data["progress"] as! Int).description + "%")
        self.status.setText(data["status"] as? String)
    }
}
