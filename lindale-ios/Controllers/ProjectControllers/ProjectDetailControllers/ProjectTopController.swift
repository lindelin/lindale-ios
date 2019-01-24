//
//  ProjectTopController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectTopController: UITableViewController {
    
    static let identity = "ProjectTop"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var projectTopResource: ProjectTopResource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
    }
    
    @objc func loadData() {
        KRProgressHUD.show()
        ProjectTopResource.load(project: self.project) { (projectTopResource) in
            self.refreshControl?.endRefreshing()
            KRProgressHUD.dismiss()
            
            guard let projectTopResource = projectTopResource else {
                self.authErrorHandle()
                return
            }
            
            self.projectTopResource = projectTopResource
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            
            var title = ""
            
            switch section {
            case 0:
                title = trans("project.status")
                break
            case 1:
                title = trans("header.progress")
                break
            case 2:
                title = trans("project.milestone")
                break
            case 3:
                title = trans("progress.status")
                break
            default:
                break
            }
            
            return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let projectTopResource = self.projectTopResource else {
            return 0
        }
        
        switch section {
        case 2:
            return projectTopResource.milestones.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        guard let projectTopResource = self.projectTopResource else {
            return cell
        }
        
        switch indexPath.section {
        case 0:
            let projectStatusCell = tableView.dequeueReusableCell(withIdentifier: ProjectStatusCell.identity, for: indexPath) as! ProjectStatusCell
            projectStatusCell.update(status: projectTopResource.status)
            cell = projectStatusCell
            break
        case 1:
            let projectProgressCell = tableView.dequeueReusableCell(withIdentifier: ProjectProgressCell.identity, for: indexPath) as! ProjectProgressCell
            projectProgressCell.updateStatus(projectTopResource.progress)
            cell = projectProgressCell
            break
        case 2:
            let projectMilestoneCell = tableView.dequeueReusableCell(withIdentifier: ProjectMilestoneCell.identity, for: indexPath) as! ProjectMilestoneCell
            projectMilestoneCell.update(with: projectTopResource.milestones[indexPath.row])
            cell = projectMilestoneCell
            break
        case 3:
            let projectActivityCell = tableView.dequeueReusableCell(withIdentifier: ProjectActivityCell.identity, for: indexPath) as! ProjectActivityCell
            projectActivityCell.update(html: projectTopResource.activity)
            cell = projectActivityCell
            break
        default:
            let projectStatusCell = tableView.dequeueReusableCell(withIdentifier: ProjectStatusCell.identity, for: indexPath) as! ProjectStatusCell
            projectStatusCell.update(status: projectTopResource.status)
            cell = projectStatusCell
            break
        }
        
        return cell
    }
}
