//
//  TaskBasicInfoCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class TaskBasicInfoCell: UITableViewCell {

    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task) {
        self.cost.text = task.cost.description
        self.group.text = task.group
        self.priority.text = task.priority
        self.start.text = task.startAt
        self.end.text = task.endAt
        self.status.text = task.status
        self.updatedAt.text = task.updatedAt
    }
    
    func setCell(taskResource: TaskResource) {
        self.cost.text = taskResource.cost.description
        self.group.text = taskResource.group
        self.priority.text = taskResource.priority
        self.start.text = taskResource.startAt
        self.end.text = taskResource.endAt
        self.status.text = taskResource.status
        self.updatedAt.text = taskResource.updatedAt
    }
}
