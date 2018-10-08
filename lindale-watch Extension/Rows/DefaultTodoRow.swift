//
//  DefaultTodoRow.swift
//  lindale-watch Extension
//
//  Created by LINDALE on 2018/10/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import WatchKit

class DefaultTodoRow: NSObject {
    @IBOutlet weak var color: WKInterfaceSeparator!
    @IBOutlet weak var projectName: WKInterfaceLabel!
    @IBOutlet weak var contents: WKInterfaceLabel!
    @IBOutlet weak var status: WKInterfaceLabel!
    
    var todo:MyTodoCollection.Todo? {
        didSet {
            guard let todo = todo else { return }
            
            self.color.setColor(Colors.get(id: todo.color))
            self.projectName.setText(todo.projectName)
            self.contents.setText(todo.content)
            self.status.setText(todo.status)
        }
    }
    
}
