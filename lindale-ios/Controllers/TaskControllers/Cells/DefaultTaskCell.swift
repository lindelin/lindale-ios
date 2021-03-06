//
//  DefaultTaskCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/14.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class DefaultTaskCell: UITableViewCell {
    
    var task: MyTaskCollection.Task? = nil
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var initiator: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var endAt: UILabel!
    @IBOutlet weak var updateAt: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var subTaskStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task) {
        self.task = task
        self.status.text = task.status
        self.title.text = "\(task.type): \(task.title)"
        self.title.textColor = Colors.get(id: task.color)
        self.type.text = "\(task.projectName): #\(task.id.description)"
        self.type.textColor = Colors.get(id: task.color)
        self.user.text = task.user?.name
        self.initiator.text = task.initiator?.name
        self.cost.text = task.cost.description
        self.group.text = task.group ?? "N/A"
        self.priority.text = task.priority
        self.startAt.text = task.startAt ?? "N/A"
        self.endAt.text = task.endAt ?? "N/A"
        self.updateAt.text = task.updatedAt
        self.progress.progress = Float(Double(task.progress) / Double(100))
        self.progress.progressTintColor = Colors.get(id: task.color)
        self.line.backgroundColor = Colors.get(id: task.color)
        self.subTaskStatus.text = task.subTaskStatus
    }

}
