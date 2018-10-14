//
//  TaskActivityCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/14.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import WebKit

class TaskActivityCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(taskActivity: TaskResource.TaskActivity) {
        self.name.text = taskActivity.user.description
        self.content.loadHTMLString(taskActivity.content, baseURL: nil)
        self.content.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self] (result, error) in
            if let height = result as? CGFloat {
                print(height)
                self!.content.frame.size.height += height
            }
        })
    }
}
