//
//  ProjectMilestoneCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/12/07.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProjectMilestoneCell: UITableViewCell {
    
    static let identity = "MilestoneCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var progress: UIProgressView!

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
        self.progress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        self.progress.progress = 0.0
    }
    
    func update(with milestone: ProjectTopResource.Milestone) {
        self.title.text = milestone.title
        self.type.text = milestone.type
        self.type.textColor = Colors.get(id: milestone.typeColor)
        self.progress.progressTintColor = Colors.get(id: milestone.color)
        self.progress.setProgress(Float(milestone.progress), animated: false)
    }
}
