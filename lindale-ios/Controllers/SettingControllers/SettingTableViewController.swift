//
//  SettingTableViewController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/09/20.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import MobileCoreServices
import KRProgressHUD

class SettingTableViewController: UITableViewController {

    var profile: Profile? = Profile.find()
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)

        self.updateUI()
        self.loadData()
        
        // MARK: - Notification Center Config
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
            self.refreshControl?.endRefreshing()
            
            guard let profile = profile else {
                self.authErrorHandle()
                return
            }
            
            self.profile = profile
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let profile = self.profile {
            self.photo.load(url: profile.photo, placeholder: UIImage(named: "lindale-launch"))
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
            
            self.present(logoutAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editPhotoButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectPhotoAction = UIAlertAction(title: "写真を選択", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: "写真を取得する権利がありません。")
                })
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let takePhotoAction = UIAlertAction(title: "カメラで撮影", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: "カメラを利用する権利がありません。")
                })
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
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

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        KRProgressHUD.show(withMessage: "Uploading...")
        let mediaType = info[.mediaType] as! String
        
        guard mediaType == (kUTTypeImage as String) else {
            KRProgressHUD.set(duration: 2.0).dismiss({
                KRProgressHUD.showError(withMessage: "写真を選択してください。")
            })
            return
        }
        
        let image = info[.editedImage] as! UIImage
        //self.photo.image = image
        Settings.ProfileInfo.upload(photo: image) { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Upload error", message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.profileInfoHasUpdated, object: nil)
            
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
            
            picker.dismiss(animated: true)
        }
    }
}
