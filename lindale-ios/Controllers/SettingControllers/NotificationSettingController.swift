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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.updateUI()
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
                KRProgressHUD.dismiss({
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
