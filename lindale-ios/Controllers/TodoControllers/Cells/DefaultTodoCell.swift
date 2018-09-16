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
    @IBOutlet weak var contents: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(todo: MyTodoCollection.Todo) {
        self.statusView.layer.backgroundColor = Colors.get(id: todo.color).cgColor
        self.line.layer.backgroundColor = Colors.get(id: todo.color).cgColor
        self.statusName.text = todo.status
        self.contents.text = todo.content
    }
}
