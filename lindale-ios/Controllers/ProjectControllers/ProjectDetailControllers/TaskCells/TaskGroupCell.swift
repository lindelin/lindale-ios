//
//  TaskGroupCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/11.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class TaskGroupCell: UITableViewCell {
    
    static let identity = "TaskGroupCell"
    
    var group: TaskGroup?

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        card.layer.cornerRadius = 5
        card.layer.masksToBounds = true
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

    func update(group: TaskGroup) {
        self.group = group
        self.colorView.backgroundColor = Colors.get(id: group.color)
        self.progress.progressTintColor = Colors.get(id: group.color)
        self.progress.setProgress(Float(Double(group.progress) / Double(100)), animated: false)
        self.title.text = group.title
        self.date.text = "\(group.startAt ?? "∞")〜\(group.endAt ?? "∞")"
        self.status.text = group.status
    }
}
