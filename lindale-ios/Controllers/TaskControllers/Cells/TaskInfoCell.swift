//
//  TaskInfoCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import WebKit

class TaskInfoCell: UITableViewCell, WKNavigationDelegate {

    @IBOutlet weak var info: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.info.navigationDelegate = self
        self.info.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(task: MyTaskCollection.Task) {
        if let content = task.content {
            self.info.loadHTMLString(content, baseURL: nil)
        }
    }
    
    func setCell(taskResource: TaskResource) {
        if let content = taskResource.content {
            self.info.loadHTMLString(content, baseURL: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Webのロード完了後に実行されるメソッド。WKNavigationDelegateのdelegateを通しておくことを忘れないこと
        let height = webView.scrollView.contentSize.height
        var frame = webView.frame
        frame.size.height = height
        webView.frame = frame
    }
}
