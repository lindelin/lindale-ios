//
//  DefaultTodoCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/15.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class DefaultTodoCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusName: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var updateAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(todo: Todo) {
        self.statusView.backgroundColor = Colors.get(id: todo.color)
        self.line.backgroundColor = Colors.get(id: todo.color)
        self.statusName.text = todo.status
        self.contents.text = todo.content
        self.projectName.text = todo.projectName
        self.statusImage.image = Actions.todo(action: todo.action)
        self.updateAt.text = todo.updatedAt
    }
}
