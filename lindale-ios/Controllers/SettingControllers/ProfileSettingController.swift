//
//  ProfileSettingController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/21.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProfileSettingController: UITableViewController {
    
    var profile: Profile!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var organization: UITextField!
    
    @IBOutlet weak var langLabelName: UILabel!
    @IBOutlet weak var langLabelContent: UILabel!
    @IBOutlet weak var langLabelOrganization: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupLangLabel()
        self.updateUI()
    }
    
    func setup() {
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = trans("user.settings")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupLangLabel() {
        self.langLabelName.text = trans("user.name")
        self.langLabelContent.text = trans("user.content")
        self.langLabelOrganization.text = trans("user.company")
    }
    
    func updateUI() {
        self.name.text = self.profile.name
        self.content.text = self.profile.content
        self.organization.text = self.profile.company
    }

    @IBAction func updateProfileInfo(_ sender: UIBarButtonItem) {
        KRProgressHUD.show(withMessage: "Updating...")
        let profileInfo = Settings.ProfileInfo(name: self.name.text ?? "",
                                               content: self.content.text ?? "",
                                               company: self.organization.text ?? "")
        profileInfo.update { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Update error", message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.profileInfoHasUpdated, object: nil)
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
        }
    }
    
    // MARK: - Navigation

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
