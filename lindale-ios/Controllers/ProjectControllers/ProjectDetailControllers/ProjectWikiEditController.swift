//
//  ProjectWikiEditController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/26.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectWikiEditController: UITableViewController {

    static let identity = "ProjectWikiEdit"
    
    var parentNavigationController: UINavigationController?
    var wiki: Wiki!
    
    @IBOutlet weak var wikiTitle: UITextField!
    @IBOutlet weak var wikiContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        self.setupNavigation()
        self.updateUI()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "Edit"
        let backButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        let updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(self.updateButtonTapped))
        self.navigationItem.rightBarButtonItem = updateButton
        
    }
    
    func updateUI() {
        self.wikiTitle.text = self.wiki.title
        self.wikiContent.text = self.wiki.originalContent
    }
    
    @objc func backButtonTapped() {
        self.parentNavigationController?.popViewController(animated: true)
    }
    
    @objc func updateButtonTapped() {
        KRProgressHUD.show(withMessage: "Updating...")
        let register = WikiRegister(id: self.wiki.id,
                                    title: self.wikiTitle.text,
                                    content: self.wikiContent.text,
                                    typeId: nil)
        register.update { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Update error", message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.wikiHasUpdated, object: nil)
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
            
            self.parentNavigationController?.popViewController(animated: true)
        }
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
