//
//  MyTaskDetailController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class MyTaskDetailController: UITableViewController {
    
    var headerView: UIView!
    
    var task: MyTaskCollection.Task!
    var taskResource: TaskResource?
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var subTaskStatus: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationController()
        self.setUpTableView()
        self.setUpHeaderView()
        self.loadData()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.subTaskHasUpdated, object: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        headerView.frame = CGRect(x: 0, y: offsetY, width: scrollView.bounds.width, height: 252)
    }
    
    func setUpTableView() {
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        self.headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(self.headerView)
        tableView.contentInset = UIEdgeInsets(top: 146, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
    }
    
    func setUpNavigationController() {
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationItem.searchController = UISearchController(searchResultsController: nil)
        //        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUpHeaderView() {
        self.taskProgress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        self.taskTitle.text = "\(self.task.type): \(self.task.title)"
        self.taskTitle.textColor = Colors.get(id: self.task.color)
        self.taskType.text = "\(self.task.projectName): #\(self.task.id.description)"
        self.taskType.textColor = Colors.get(id: self.task.color)
        self.taskProgress.progress = Float(Double(self.task.progress) / Double(100))
        self.taskProgress.progressTintColor = Colors.get(id: self.task.color)
        self.subTaskStatus.text = self.task.subTaskStatus
    }
    
    func updateHeaderView() {
        if let taskResource = self.taskResource {
            self.taskTitle.text = "\(taskResource.type): \(taskResource.title)"
            self.taskTitle.textColor = Colors.get(id: taskResource.color)
            self.taskType.text = "\(taskResource.project): #\(taskResource.id.description)"
            self.taskType.textColor = Colors.get(id: taskResource.color)
            self.taskProgress.setProgress(Float(Double(taskResource.progress) / Double(100)), animated: true)
            self.taskProgress.progressTintColor = Colors.get(id: taskResource.color)
            self.subTaskStatus.text = taskResource.subTaskStatus
        }
    }
    
    @objc func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        TaskResource.load(id: self.task.id) { (taskResource) in
            if let taskResource = taskResource {
                self.taskResource = taskResource
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.updateHeaderView()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.tableView.separatorStyle = .singleLine
            break
        case 1:
            self.tableView.separatorStyle = .none
            break
        case 2:
            self.tableView.separatorStyle = .singleLine
            break
        default:
            self.tableView.separatorStyle = .none
            break
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionCount = 1
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            sectionCount = 4
            break
        case 1:
            sectionCount = 1
            break
        case 2:
            sectionCount = 1
            break
        default:
            break
        }
        
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var cellCount = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if section == 2 {
                cellCount = 7
            } else {
                cellCount = 1
            }
            break
        case 1:
            if let taskResource = self.taskResource {
                cellCount = taskResource.subTasks.count
            }
            break
        case 2:
            if let taskResource = self.taskResource {
                cellCount = taskResource.taskActivities.count
            }
            break
        default:
            break
        }
        
        return cellCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell = self.getOverviewSectionCell(for: indexPath)
            break
        case 1:
            let id = String(describing: SubTaskCell.self)
            let subTaskCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubTaskCell
            if let taskResource = self.taskResource {
                subTaskCell.setCell(subTask: taskResource.subTasks[indexPath.row])
            }
            cell = subTaskCell
            break
        case 2:
            let id = String(describing: TaskActivityCell.self)
            let taskActivityCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskActivityCell
            if let taskResource = self.taskResource {
                taskActivityCell.setCell(taskActivity: taskResource.taskActivities[indexPath.row])
            }
            cell = taskActivityCell
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
            break
        }
        
        return cell
    }
    
    func getOverviewSectionCell(for indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        switch indexPath.section {
        case 0:
            let id = String(describing: TaskUserInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskUserInfoCell
            if let taskResource = self.taskResource {
                sectionCell.setCell(user: taskResource.user)
            } else {
                sectionCell.setCell(task: self.task)
            }
            sectionCell.label.text = "担当者"
            sectionCell.label.textColor = Colors.themeBlue
            cell = sectionCell
            break
        case 1:
            let id = String(describing: TaskUserInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskUserInfoCell
            if let taskResource = self.taskResource {
                sectionCell.setCell(user: taskResource.initiator)
            } else {
                sectionCell.setCell(task: self.task, isInitiator: true)
            }
            sectionCell.label.text = "起票者"
            sectionCell.label.textColor = Colors.themeGreen
            cell = sectionCell
            break
        case 2:
            cell = self.getBasicCell(from: indexPath)
            break
        case 3:
            let id = String(describing: TaskInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskInfoCell
            if let taskResource = self.taskResource {
                sectionCell.setCell(taskResource: taskResource)
            } else {
                sectionCell.setCell(task: self.task)
            }
            cell = sectionCell
            break
        default:
            let id = String(describing: TaskInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskInfoCell
            sectionCell.setCell(task: self.task)
            cell = sectionCell
            break
        }
        
        return cell
    }
    
    func getBasicCell(from indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskBasicCell", for: indexPath)
        cell.textLabel?.textColor = Colors.themeBaseSub
        cell.detailTextLabel?.textColor = Colors.themeBase
        cell.detailTextLabel?.numberOfLines = 0
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "予定工数"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.cost.description
            } else {
                cell.detailTextLabel?.text = task.cost.description
            }
            break
        case 1:
            cell.textLabel?.text = "グループ"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.group
            } else {
                cell.detailTextLabel?.text = task.group
            }
            break
        case 2:
            cell.textLabel?.text = "優先度"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.priority
            } else {
                cell.detailTextLabel?.text = task.priority
            }
            break
        case 3:
            cell.textLabel?.text = "開始日"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.startAt
            } else {
                cell.detailTextLabel?.text = task.startAt
            }
            break
        case 4:
            cell.textLabel?.text = "期限日"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.endAt
            } else {
                cell.detailTextLabel?.text = task.endAt
            }
            break
        case 5:
            cell.textLabel?.text = "ステータス"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.status
            } else {
                cell.detailTextLabel?.text = task.status
            }
            break
        case 6:
            cell.textLabel?.text = "最終更新日"
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.updatedAt
            } else {
                cell.detailTextLabel?.text = task.updatedAt
            }
            break
        default:
            break
        }
        
        return cell
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