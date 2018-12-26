//
//  ProjectWikiDetailController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/26.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ProjectWikiDetailController: UIViewController, WKNavigationDelegate {

    static let identity = "ProjectWikiDetail"
    
    var parentNavigationController: UINavigationController?
    var wiki: Wiki!
    
    @IBOutlet weak var wikiContents: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wikiContents.navigationDelegate = self
        
        self.setupNavigation()
        
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = self.wiki.title
    }
    
    func updateUI() {
        self.wikiContents.loadHTMLString(self.wiki.content, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url {
            print(url)
            let safariViewController = SFSafariViewController(url: url)
            let navigationController = UINavigationController(rootViewController: safariViewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            self.present(navigationController, animated: true, completion: nil)
        }
        
        decisionHandler(.cancel)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
