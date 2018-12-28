//
//  ProjectTaskController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import CircleMenu

class ProjectTaskController: UITableViewController {
    
    static let identity = "ProjectTasks"
    
    var addBtn = UIButton(type: .custom)
    
    func floatingButton() {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        addBtn.frame = CGRect(x: window.frame.width - 64 - 20 ,
                              y: window.frame.height - Size.tabBarHeight - 64 - 20,
                              width: 64,
                              height: 64)
        
        addBtn.backgroundColor = Colors.themeGreen
        addBtn.setImage(UIImage(named: "plus-56"), for: .normal)
        addBtn.tintColor = UIColor.white
        addBtn.clipsToBounds = true
        addBtn.layer.cornerRadius = addBtn.frame.size.width / 2.0
        addBtn.layer.shadowRadius = 10
        addBtn.layer.shadowOpacity = 0.3
        addBtn.layer.shadowColor = Colors.themeBaseSub.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        addBtn.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
        
        window.addSubview(addBtn)
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        floatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addBtn.removeFromSuperview()
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        UIView.transition(with: addBtn, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.addBtn.isHidden = true
        })
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.transition(with: addBtn, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.addBtn.isHidden = false
        })
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

    // MARK: -  Add Button
    @objc func addButtonTapped() {
        // TODO
    }
}
