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
    
    // MARK: - language label
    @IBOutlet weak var langLabelCost: UILabel!
    @IBOutlet weak var langlabelUpdateAt: UILabel!
    @IBOutlet weak var langLabelStatus: UILabel!
    @IBOutlet weak var langLabelPriority: UILabel!
    @IBOutlet weak var langLabelGroup: UILabel!
    @IBOutlet weak var langLabelStart: UILabel!
    @IBOutlet weak var langLabelEnd: UILabel!
    
    func setupLangLabel() {
        self.langLabelCost.text = trans("task.cost")
        self.langlabelUpdateAt.text = trans("task.updated")
        self.langLabelStatus.text = trans("task.status")
        self.langLabelPriority.text = trans("task.priority")
        self.langLabelGroup.text = trans("task.group")
        self.langLabelStart.text = trans("task.start_at")
        self.langLabelEnd.text = trans("task.end_at")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task) {
        self.setupLangLabel()
        self.cost.text = task.cost.description
        self.group.text = task.group
        self.priority.text = task.priority
        self.start.text = task.startAt
        self.end.text = task.endAt
        self.status.text = task.status
        self.updatedAt.text = task.updatedAt
    }
    
    func setCell(taskResource: TaskResource) {
        self.setupLangLabel()
        self.cost.text = taskResource.cost.description
        self.group.text = taskResource.group
        self.priority.text = taskResource.priority
        self.start.text = taskResource.startAt
        self.end.text = taskResource.endAt
        self.status.text = taskResource.status
        self.updatedAt.text = taskResource.updatedAt
    }
}
