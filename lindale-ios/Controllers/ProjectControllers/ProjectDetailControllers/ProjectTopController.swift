//
//  ProjectTopController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProjectTopController: UITableViewController {
    
    static let identity = "ProjectTop"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var projectTopResource: ProjectTopResource?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    @objc func loadData() {
        ProjectTopResource.load(project: self.project) { (projectTopResource) in
            guard let projectTopResource = projectTopResource else {
                self.authErrorHandle()
                return
            }
            self.projectTopResource = projectTopResource
            self.updateUI()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let projectTopResource = self.projectTopResource else {
            return 0
        }
        if projectTopResource.milestones.count > 0 {
            return 4
        }
        
        return 3
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
