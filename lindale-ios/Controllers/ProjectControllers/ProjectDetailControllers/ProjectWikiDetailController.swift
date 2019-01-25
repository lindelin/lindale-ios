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
    var project: ProjectCollection.Project!
    var wikiTypes: [WikiType]!
    var wikiType: WikiType!
    var wiki: Wiki!
    
    @IBOutlet weak var wikiContents: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wikiContents.navigationDelegate = self
        
        self.setupNavigation()
        
        // Do any additional setup after loading the view.
        self.updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.wikiHasUpdated, object: nil)
    }
    
    private func setupNavigation() {
        self.navigationItem.title = self.wiki.title
        let backButton = UIBarButtonItem(image: UIImage(named: "back-30"), style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        let editButton = UIBarButtonItem(image: UIImage(named: "pencil-24"), style: .plain, target: self, action: #selector(self.editButtonTapped))
        editButton.tintColor = Colors.themeBlue
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func loadData() {
        Wiki.find(id: wiki.id) { (wiki) in
            
            guard let wiki = wiki else {
                self.authErrorHandle()
                return
            }
            
            self.wiki = wiki
            self.setupNavigation()
            self.updateUI()
        }
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
    
    @objc func editButtonTapped() {
        let wiki = self.wiki
        let storyboard = UIStoryboard(name: "ProjectWiki", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ProjectWikiEditController.identity) as! ProjectWikiEditController
        controller.parentNavigationController = self.parentNavigationController
        controller.project = self.project
        controller.wikiTypes = self.wikiTypes
        controller.wikiType = self.wikiType
        controller.wiki = wiki
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.parentNavigationController?.popViewController(animated: true)
    }
}
