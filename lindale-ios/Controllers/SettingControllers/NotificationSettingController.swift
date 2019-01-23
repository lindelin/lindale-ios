//
//  NotificationSettingController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class NotificationSettingController: UITableViewController {
    
    var notificationSettings: Settings.Notification!
    
    @IBOutlet weak var slack: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.updateUI()
    }
    
    func setup() {
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = trans("config.notification")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    func updateUI() {
        slack.isOn = self.notificationSettings.slackIsOn()
    }

    @IBAction func updateSlack(_ sender: UISwitch) {
        KRProgressHUD.show(withMessage: "Updating...")
        if sender.isOn {
            self.notificationSettings.slack = Settings.Notification.on
        } else {
            self.notificationSettings.slack = Settings.Notification.off
        }
        
        self.notificationSettings.update { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: response["messages"])
                })
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
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
