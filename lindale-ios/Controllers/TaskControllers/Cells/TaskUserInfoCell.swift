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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var name: UILabel!
    
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
            self.name.text = task.user?.name
        } else {
            self.name.text = task.initiator?.name
        }
    }
    
    func setCell(user: User?) {
        if let user = user {
            self.photo.load(url: user.photo, placeholder: UIImage(named: "user-30"))
            self.name.text = "\(user.name)（\(user.email)）"
        } else {
            self.photo.image = UIImage(named: "user-30")
            self.name.text = "System"
        }
    }

}
