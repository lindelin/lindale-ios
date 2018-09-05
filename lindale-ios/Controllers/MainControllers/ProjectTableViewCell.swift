//
//  ProjectTableViewCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var todoStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(project: ProjectCollection.Project) {
        self.projectImage.image = #imageLiteral(resourceName: "lindale-launch")
        self.projectImage.downloadedFrom(link: project.image!)
        self.type.text = project.type
        self.title.text = project.title
        self.progress.progress = Float(Double(project.progress!) / Double(100))
        self.progressText.text = project.progress!.description + "%"
        self.taskStatus.text = project.taskStatus
        self.todoStatus.text = project.todoStatus
    }
}
