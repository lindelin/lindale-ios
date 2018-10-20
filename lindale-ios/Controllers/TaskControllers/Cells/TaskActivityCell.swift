//
//  TaskActivityCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/14.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Down

class TaskActivityCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(taskActivity: TaskResource.TaskActivity) {
        self.photo.load(url: URL(string: taskActivity.user.photo!)!, placeholder: UIImage(named: "user-30"))
        self.name.text = taskActivity.user.name
        self.date.text = taskActivity.updateAt
        self.content.attributedText = try? Down(markdownString: taskActivity.content).toAttributedString()
    }
}
