//
//  ProfileStatusCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/09/11.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class ProfileStatusCell: UITableViewCell {
    
    @IBOutlet weak var totalProgress: UIProgressView!
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var todoProgress: UIProgressView!
    @IBOutlet weak var totalProgressText: UILabel!
    @IBOutlet weak var taskProgressText: UILabel!
    @IBOutlet weak var todoProgressText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        totalProgress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        taskProgress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        todoProgress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        self.totalProgress.progress = 0.0
        self.taskProgress.progress = 0.0
        self.todoProgress.progress = 0.0
        self.totalProgressText.text = "0%"
        self.taskProgressText.text = "0%"
        self.todoProgressText.text = "0%"
    }
    
    func updateStatus(_ progress: Profile.Progress) {
        self.totalProgress.progress = Float(Double(progress.total) / Double(100))
        self.taskProgress.progress = Float(Double(progress.task) / Double(100))
        self.todoProgress.progress = Float(Double(progress.todo) / Double(100))
        self.totalProgressText.text = (progress.total.description) + "%"
        self.taskProgressText.text = (progress.task.description) + "%"
        self.todoProgressText.text = (progress.todo.description) + "%"
    }

}
