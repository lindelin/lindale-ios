//
//  FoldingTaskCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/11/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class FoldingTaskCell: UITableViewCell {
    
    var task: MyTaskCollection.Task? = nil

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var projectNameAndCode: UILabel!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var subTaskStatus: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var initiatorName: UILabel!
    @IBOutlet weak var initiatorEmail: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var endAt: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    
    
    override func awakeFromNib() {
        card.layer.cornerRadius = 10
        card.layer.masksToBounds = true
        super.awakeFromNib()
        // Initialization code
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task) {
        self.task = task
        self.colorView.backgroundColor = Colors.get(id: task.color)
        self.colorBar.backgroundColor = Colors.get(id: task.color)
        self.projectNameAndCode.text = "\(task.projectName) #\(task.id)"
        self.progress.text = "\(task.progress)%"
        self.title.text = "\(task.type): \(task.title)"
        self.progressBar.progress = Float(Double(task.progress) / Double(100))
        self.progressBar.progressTintColor = Colors.get(id: task.color)
        self.subTaskStatus.text = task.subTaskStatus
        self.status.text = task.status
        self.priority.text = task.priority
        self.group.text = task.group ?? "None"
        self.startAt.text = task.startAt
        self.endAt.text = task.endAt
        self.updatedAt.text = task.updatedAt
    }

}
