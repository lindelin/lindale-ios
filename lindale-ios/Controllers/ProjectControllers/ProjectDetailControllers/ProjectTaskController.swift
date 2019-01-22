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
        
        self.setupFloatyButton()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskGroupHasUpdated, object: nil)
    }
    
    private func setupFloatyButton() {
        let floaty = Floaty()
        floaty.addItem("New Group", icon: UIImage(named: "task-group-30")!, handler: { item in
            KRProgressHUD.show(withMessage: "Loading...")
            TaskGroup.EditResources.resources(project: self.project, completion: { (editResources) in
                guard let editResources = editResources else {
                    KRProgressHUD.set(duration: 2.0).dismiss({
                        KRProgressHUD.showError(withMessage: "作成できません。")
                    })
                    return
                }
                
                let storyboard = UIStoryboard(name: "ProjectTask", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: TaskGroupCreateController.identity) as! TaskGroupCreateController
                controller.parentNavigationController = self.parentNavigationController
                controller.project = self.project
                controller.editResource = editResources
                KRProgressHUD.dismiss()
                self.parentNavigationController?.pushViewController(controller, animated: true)
            })
            floaty.close()
        })
        floaty.addItem("New Task", icon: UIImage(named: "task-30")!, handler: { item in
            // TODO
            floaty.close()
        })
        floaty.sticky = true
        floaty.buttonColor = Colors.themeGreen
        floaty.plusColor = UIColor.white
        self.view.addSubview(floaty)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            KRProgressHUD.show(withMessage: "Loading...")
            TaskGroup.EditResources.resources(project: self.project, completion: { (editResources) in
                guard let editResources = editResources else {
                    KRProgressHUD.set(duration: 2.0).dismiss({
                        KRProgressHUD.showError(withMessage: "編集できません。")
                    })
                    return
                }
                
                let cell = tableView.cellForRow(at: indexPath) as! TaskGroupCell
                let storyboard = UIStoryboard(name: "ProjectTask", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: TaskGroupEditController.identity) as! TaskGroupEditController
                controller.parentNavigationController = self.parentNavigationController
                controller.project = self.project
                controller.taskGroup = cell.group
                controller.editResource = editResources
                KRProgressHUD.dismiss()
                self.parentNavigationController?.pushViewController(controller, animated: true)
            })
        }
        
        editAction.backgroundColor = Colors.themeYellow
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    // MARK: -  Add Button
    @objc func addButtonTapped() {
        // TODO
    }
}
