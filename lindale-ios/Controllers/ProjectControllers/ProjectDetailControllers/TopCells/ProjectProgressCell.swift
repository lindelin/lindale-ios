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
    
    // MARK: - language label
    @IBOutlet weak var langLabelTotal: UILabel!
    @IBOutlet weak var langLabelTask: UILabel!
    
    func setupLangLabel() {
        self.langLabelTotal.text = trans("header.progress")
        self.langLabelTask.text = trans("header.tasks")
    }
    
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
        self.setupLangLabel()
        self.totalProgressBar.setProgress(Float(Double(progress.total) / Double(100)), animated: false)
        self.taskProgressBar.setProgress(Float(Double(progress.task) / Double(100)), animated: false)
        self.todoProgressBar.setProgress(Float(Double(progress.todo) / Double(100)), animated: false)
        self.totalProgress.text = "\(progress.total)%"
        self.taskProgress.text = "\(progress.task)%"
        self.todoProgress.text = "\(progress.todo)%"
    }
}
