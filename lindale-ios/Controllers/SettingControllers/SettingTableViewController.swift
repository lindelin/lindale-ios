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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.preUpdateUI()
        self.loadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "ProfileSettings", sender: nil)
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "AccountSettings", sender: nil)
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            performSegue(withIdentifier: "LocalSettings", sender: nil)
        }
        if indexPath.section == 1 && indexPath.row == 2 {
            performSegue(withIdentifier: "NotificationSettings", sender: nil)
        }
    }
    
    func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Profile.resources { (profile) in
            if let profile = profile {
                self.updateUI(with: profile)
            } else {
                //self.logout()
            }
        }
    }
    
    func updateUI(with profile: Profile) {
        self.profile = profile
        self.photo.load(url: URL(string: profile.photo!)!, placeholder: UIImage(named: "lindale-launch"))
        self.name.text = profile.name
        self.email.text = profile.email
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func preUpdateUI() {
        if self.profile != nil {
            self.photo.load(url: URL(string: self.profile!.photo!)!, placeholder: UIImage(named: "lindale-launch"))
            self.name.text = self.profile!.name
            self.email.text = self.profile!.email
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
