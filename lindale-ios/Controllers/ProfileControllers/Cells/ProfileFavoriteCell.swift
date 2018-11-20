//
//  ProfileFavoriteCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/12.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class ProfileFavoriteCell: UITableViewCell {
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var todos: UILabel!
    @IBOutlet weak var progress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProject(_ project: ProjectCollection.Project) {
        self.projectImage.load(url: project.image, placeholder: #imageLiteral(resourceName: "lindale-launch"))
        self.name.text = project.title
        self.type.text = project.type
        self.tasks.text = project.taskStatus
        self.todos.text = project.todoStatus
        self.progress.text = (project.progress?.description)! + "%"
    }
}
