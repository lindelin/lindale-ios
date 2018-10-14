//
//  TaskUserInfoCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class TaskUserInfoCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task, isInitiator: Bool = false) {
        if isInitiator {
            self.name.text = task.userName
            self.email.text = "..."
        } else {
            self.name.text = task.initiatorName
            self.email.text = "..."
        }
    }
    
    func setCell(user: TaskResource.User) {
        self.photo.load(url: URL(string: user.photo!)!, placeholder: UIImage(named: "user-30"))
        self.name.text = user.name
        self.email.text = user.email
    }

}
