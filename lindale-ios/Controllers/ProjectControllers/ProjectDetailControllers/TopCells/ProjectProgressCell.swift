//
//  ProjectProgressCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/12/07.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProjectProgressCell: UITableViewCell {
    
    static let identity = "ProgressCell"

    @IBOutlet weak var totalProgressBar: UIProgressView!
    @IBOutlet weak var totalProgress: UILabel!
    @IBOutlet weak var taskProgressBar: UIProgressView!
    @IBOutlet weak var taskProgress: UILabel!
    @IBOutlet weak var todoProgressBar: UIProgressView!
    @IBOutlet weak var todoProgress: UILabel!
    
    
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
        totalProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        taskProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        todoProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        self.totalProgressBar.progress = 0.0
        self.taskProgressBar.progress = 0.0
        self.todoProgressBar.progress = 0.0
        self.totalProgress.text = "0%"
        self.taskProgress.text = "0%"
        self.todoProgress.text = "0%"
    }
    
    func updateStatus(_ progress: ProjectTopResource.Progress) {
        self.totalProgressBar.setProgress(Float(progress.total), animated: false)
        self.taskProgressBar.setProgress(Float(progress.task), animated: false)
        self.todoProgressBar.setProgress(Float(progress.todo), animated: false)
        self.totalProgress.text = "\(progress.total)%"
        self.taskProgress.text = "\(progress.task)%"
        self.todoProgress.text = "\(progress.todo)%"
    }
}
