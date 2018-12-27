//
//  ProjectTaskController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectTaskController: UITableViewController {
    
    static let identity = "ProjectTasks"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var taskGroupCollection: TaskGroupCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
    }
    
    @objc func loadData() {
        KRProgressHUD.show(withMessage: "Loading...")
        TaskGroup.resources(project: self.project) { (taskGroupCollection) in
            self.refreshControl?.endRefreshing()
            KRProgressHUD.dismiss()
            
            guard let taskGroupCollection = taskGroupCollection else {
                self.authErrorHandle()
                return
            }
            
            self.taskGroupCollection = taskGroupCollection
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let taskGroupCollection = self.taskGroupCollection else {
            return 0
        }
        
        return taskGroupCollection.groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskGroupCell.identity, for: indexPath) as! TaskGroupCell
        
        cell.backgroundColor = .clear

        cell.update(group: self.taskGroupCollection!.groups[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskGroupCell
        let storyboard = UIStoryboard(name: "ProjectTask", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ProjectGroupTasksController.identity) as! ProjectGroupTasksController
        controller.parentNavigationController = self.parentNavigationController
        controller.project = self.project
        controller.taskGroup = cell.group
        self.parentNavigationController?.pushViewController(controller, animated: true)
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
