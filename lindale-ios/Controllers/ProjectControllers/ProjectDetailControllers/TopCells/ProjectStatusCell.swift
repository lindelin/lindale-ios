//
//  ProjectStatusCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/12/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProjectStatusCell: UITableViewCell {
    
    static let identity = "StatusCell"

    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var todo: UILabel!
    @IBOutlet weak var event: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(status: ProjectTopResource.Status) {
        self.task.text = status.task
        self.todo.text = status.todo
        self.event.text = status.event
    }
}
