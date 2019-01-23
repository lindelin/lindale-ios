//
//  ProfileTableViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/07.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    var profile: Profile? = Profile.find()
    var favorites: [ProjectCollection.Project] = []
    var myProjects: [ProjectCollection.Project] = []
    var userProjects: [ProjectCollection.Project] = []
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var projectCount: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    @IBOutlet weak var todoCount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.localeSettingsHasUpdated, object: nil)
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
        ProjectCollection.favorites { (favorites) in
            guard let favorites = favorites else {
                self.authErrorHandle()
                return
            }
            self.favorites = favorites
        }
    }
    
    func updateUI() {
        if let profile = self.profile {
            self.photo.load(url: profile.photo, placeholder: #imageLiteral(resourceName: "lindale-launch"))
            self.projectCount.text = profile.status.projectCount.description
            self.taskCount.text = profile.status.unfinishedTaskCount.description
            self.todoCount.text = profile.status.unfinishedTodoCount.description
            self.name.text = profile.name
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table Sections Config
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 1
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            sectionCount = 2
            break
        case 1:
            sectionCount = 1
            break
        case 2:
            sectionCount = 0
            if self.myProjects.count > 0 {
                sectionCount += 1
            }
            if self.userProjects.count > 0 {
                sectionCount += 1
            }
            break
        default:
            break
        }
        
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            
            var title = ""
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                if section == 0 {
                    title = trans("header.progress")
                } else {
                    title = trans("progress.status")
                }
                break
            case 1:
                title = trans("project.favorite")
                break
            case 2:
                if section == 0 {
                    title = trans("project.projects-manage")
                } else {
                    title = trans("project.projects-join")
                }
                break
            default:
                break
            }
            
            return title
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // MARK: - Table Row Config
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount = 0
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cellCount = 1
            break
        case 1:
            cellCount = self.favorites.count
            break
        case 2:
            if section == 0 {
                cellCount = self.myProjects.count
            } else {
                cellCount = self.userProjects.count
            }
            break
        default:
            break
        }
        
        return cellCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if indexPath.section == 0 {
                let id = String(describing: ProfileStatusCell.self)
                let profileStatusCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ProfileStatusCell
                if let profile = self.profile {
                    profileStatusCell.updateStatus(profile.progress)
                }
                cell = profileStatusCell
            } else {
                let id = String(describing: ActivityViewCell.self)
                let activityViewCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ActivityViewCell
                if let profile = self.profile {
                    activityViewCell.update(html: profile.activity)
                }
                cell = activityViewCell
            }
            
            break
        case 1:
            let id = String(describing: ProfileFavoriteCell.self)
            let profileFavoriteCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ProfileFavoriteCell
            if self.favorites.count > 0 {
                profileFavoriteCell.setProject(self.favorites[indexPath.row])
            }
            cell = profileFavoriteCell
            break
        case 2:
            let id = String(describing: ProfileFavoriteCell.self)
            let profileFavoriteCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ProfileFavoriteCell
            if self.favorites.count > 0 {
                profileFavoriteCell.setProject(self.favorites[indexPath.row])
            }
            cell = profileFavoriteCell
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
            break
        }
        
        return cell
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.tableView.reloadData()
            break
        case 1:
            self.tableView.reloadData()
            break
        case 2:
            self.tableView.reloadData()
            break
        default:
            break
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
