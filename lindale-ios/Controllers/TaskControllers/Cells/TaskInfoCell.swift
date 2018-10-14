//
//  TaskInfoCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import WebKit

class TaskInfoCell: UITableViewCell {

    @IBOutlet weak var info: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task) {
        if let content = task.content {
            self.info.loadHTMLString(content, baseURL: nil)
        }
    }
    
    func setCell(taskResource: TaskResource) {
        if let content = taskResource.content {
            self.info.loadHTMLString(content, baseURL: nil)
        }
    }
}
