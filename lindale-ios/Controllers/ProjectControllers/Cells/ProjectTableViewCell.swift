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
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var todoStatus: UILabel!
    @IBOutlet weak var plImage: UIImageView!
    @IBOutlet weak var plName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.progress.transform = self.progress.transform.scaledBy(x: 1, y: 3
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(project: ProjectCollection.Project) {
        self.projectImage.image = #imageLiteral(resourceName: "lindale-launch")
        self.projectImage.load(url: project.image, placeholder: #imageLiteral(resourceName: "lindale-launch"))
        self.type.text = project.type
        self.status.text = project.status ?? "New"
        self.title.text = project.title
        self.progress.progress = Float(Double(project.progress!) / Double(100))
        self.progressText.text = project.progress!.description + "%"
        self.taskStatus.text = project.taskStatus
        self.todoStatus.text = project.todoStatus
        self.plImage.load(url: project.pl.photo, placeholder: #imageLiteral(resourceName: "lindale-launch"))
        self.plName.text = project.pl.name
    }
}
