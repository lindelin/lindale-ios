//
//  SettingTableViewController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/09/20.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    var profile: Profile? = Profile.find()
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.updateUI()
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.profileInfoHasUpdated, object: nil)
    }
    
    private func setupNavigation() {
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    @objc func loadData() {
        Profile.resources { (profile) in
            if let profile = profile {
                self.profile = profile
                self.updateUI()
            } else {
                self.authErrorHandle()
            }
        }
    }
    
    func updateUI() {
        if let profile = self.profile {
            self.photo.load(url: URL(string: profile.photo!)!, placeholder: UIImage(named: "lindale-launch"))
            self.name.text = profile.name
            self.email.text = profile.email
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "ProfileSettings", sender: self.profile)
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "AccountSettings", sender: nil)
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            Settings.Locale.load { (localeSettings) in
                if let localeSettings = localeSettings {
                    self.performSegue(withIdentifier: "LocalSettings", sender: localeSettings)
                }
            }
        }
        if indexPath.section == 1 && indexPath.row == 2 {
            Settings.Notification.load { (notificationSettings) in
                if let notificationSettings = notificationSettings {
                    self.performSegue(withIdentifier: "NotificationSettings", sender: notificationSettings)
                }
            }
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            let logoutAlert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: .actionSheet)
            
            let noAction = UIAlertAction(title: "いいえ", style: .cancel, handler: { (action: UIAlertAction) in
                logoutAlert.dismiss(animated: true, completion: nil)
            })
            
            let yesAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction) in
                self.logout()
            })
            
            logoutAlert.addAction(noAction)
            logoutAlert.addAction(yesAction)
            
            if self.presentingViewController == nil {
                self.view.window?.rootViewController?.present(logoutAlert, animated: true, completion: nil)
            }else {
                self.present(logoutAlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "LocalSettings" {
            let destination = segue.destination as! LanguageSettingController
            destination.localeSettings = sender as? Settings.Locale
        }
        
        if segue.identifier == "NotificationSettings" {
            let destination = segue.destination as! NotificationSettingController
            destination.notificationSettings = sender as? Settings.Notification
        }
        
        if segue.identifier == "ProfileSettings" {
            let destination = segue.destination as! ProfileSettingController
            destination.profile = sender as? Profile
        }
    }
}
