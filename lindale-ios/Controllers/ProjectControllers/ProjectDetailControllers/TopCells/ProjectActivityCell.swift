//
//  ProjectActivityCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/12/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import WebKit

class ProjectActivityCell: UITableViewCell {
    
    static let identity = "ActivityCell"

    @IBOutlet weak var activity: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.activity.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(html: String) {
        self.activity.loadHTMLString(html, baseURL: nil)
    }
}
