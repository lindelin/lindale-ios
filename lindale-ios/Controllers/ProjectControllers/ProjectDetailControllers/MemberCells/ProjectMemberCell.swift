//
//  ProjectMemberCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProjectMemberCell: UITableViewCell {
    
    static let identity = "ProjectMemberCell"

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var role: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var projectStatus: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var todoStatus: UILabel!
    
    enum Role: String {
        case pl = "pl-30"
        case sl = "sl-30"
        case mb = "member-30"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func update(user: Profile, role: Role) {
        self.photo.load(url: user.photo, placeholder: UIImage(named: "lindale-launch"))
        self.role.image = UIImage(named: role.rawValue)
        self.name.text = user.name
        self.email.text = user.email
        self.projectStatus.text = user.status.projectCount.description
        self.taskStatus.text = user.status.unfinishedTaskCount.description
        self.todoStatus.text = user.status.unfinishedTodoCount.description
    }
}
