//
//  ActivityViewCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/10/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import WebKit

class ActivityViewCell: UITableViewCell {
    
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
