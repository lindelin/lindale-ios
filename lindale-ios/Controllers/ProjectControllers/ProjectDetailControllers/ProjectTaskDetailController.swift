//
//  ProjectTaskDetailController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/27.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import SCLAlertView

class ProjectTaskDetailController: UITableViewController, UINavigationControllerDelegate {
    
    static let identity = "ProjectTaskDetail"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var task: MyTaskCollection.Task!
    var taskResource: TaskResource?
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var subTaskStatus: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup
        self.setUpTableView()
        self.setUpHeaderView()
        
        self.loadData()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        // MARK: - Notification Center Config
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.subTaskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskActivityHasUpdated, object: nil)
    }
    
    func setUpTableView() {
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
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
        TaskResource.load(id: self.task.id) { (taskResource) in
            self.refreshControl?.endRefreshing()
            
            guard let taskResource = taskResource else {
                self.authErrorHandle()
                return
            }
            
            self.taskResource = taskResource
            self.updateHeaderView()
            self.tableView.reloadData()
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
            if section == 3 {
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
        case 1:
            let id = String(describing: TaskUserInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskUserInfoCell
            if let taskResource = self.taskResource {
                sectionCell.setCell(user: taskResource.user)
            } else {
                sectionCell.setCell(task: self.task)
            }
            sectionCell.label.text = trans("task.user")
            sectionCell.label.textColor = Colors.themeBlue
            cell = sectionCell
            break
        case 2:
            let id = String(describing: TaskUserInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskUserInfoCell
            if let taskResource = self.taskResource {
                sectionCell.setCell(user: taskResource.initiator)
            } else {
                sectionCell.setCell(task: self.task, isInitiator: true)
            }
            sectionCell.label.text = trans("todo.initiator")
            sectionCell.label.textColor = Colors.themeGreen
            cell = sectionCell
            break
        case 3:
            cell = self.getBasicCell(from: indexPath)
            break
        case 0:
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
            cell.textLabel?.text = trans("task.cost")
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = "\(taskResource.cost.description) \(trans("task.hour"))"
            } else {
                cell.detailTextLabel?.text = "\(task.cost) \(trans("task.hour"))"
            }
            break
        case 1:
            cell.textLabel?.text = trans("task.group")
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.group
            } else {
                cell.detailTextLabel?.text = task.group
            }
            break
        case 2:
            cell.textLabel?.text = trans("task.priority")
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.priority
            } else {
                cell.detailTextLabel?.text = task.priority
            }
            break
        case 3:
            cell.textLabel?.text = trans("task.start_at")
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.startAt
            } else {
                cell.detailTextLabel?.text = task.startAt
            }
            break
        case 4:
            cell.textLabel?.text = trans("task.end_at")
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.endAt
            } else {
                cell.detailTextLabel?.text = task.endAt
            }
            break
        case 5:
            cell.textLabel?.text = trans("task.status")
            if let taskResource = self.taskResource {
                cell.detailTextLabel?.text = taskResource.status
            } else {
                cell.detailTextLabel?.text = task.status
            }
            break
        case 6:
            cell.textLabel?.text = trans("task.updated")
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
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: "\(self.taskResource?.title ?? self.task.title)\(trans("task.delete-title"))", preferredStyle: .actionSheet)
        
        let noAction = UIAlertAction(title: trans("task.cancel"), style: .cancel, handler: { (action: UIAlertAction) in
            actionSheet.dismiss(animated: true, completion: nil)
        })
        
        let yesAction = UIAlertAction(title: trans("task.delete"), style: .default, handler: { (action: UIAlertAction) in
            KRProgressHUD.show()
            
            guard let taskResource = self.taskResource else {
                KRProgressHUD.dismiss({
                    KRProgressHUD.showError(withMessage: trans("errors.network-error", option: "Network Error!"))
                })
                return
            }
            
            taskResource.delete(completion: { (response) in
                guard response["status"] == "OK" else {
                    self.showAlert(title: trans("errors.delete-failed"), message: response["messages"]!)
                    KRProgressHUD.dismiss()
                    return
                }
                
                NotificationCenter.default.post(name: LocalNotificationService.taskHasDeleted, object: nil)
                KRProgressHUD.dismiss({
                    KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                })
                self.navigationController?.popViewController(animated: true)
            })
        })
        
        actionSheet.addAction(noAction)
        actionSheet.addAction(yesAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: trans("task.cancel"), style: .cancel, handler: { (action: UIAlertAction) in
            actionSheet.dismiss(animated: true, completion: nil)
        })
        
        let taskEditAction = UIAlertAction(title: trans("task.edit-task"), style: .default, handler: { (action: UIAlertAction) in
            KRProgressHUD.show()
            guard let taskResource = self.taskResource else {
                KRProgressHUD.dismiss({
                    KRProgressHUD.showError(withMessage: trans("errors.network-error", option: "Network Error!"))
                })
                return
            }
            TaskResource.EditResources.load(task: taskResource, completion: { (resource) in
                guard let resource = resource else {
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showError(withMessage: trans("errors.network-error", option: "Network Error!"))
                    })
                    return
                }
                
                let storyboard = UIStoryboard(name: "ProjectTask", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: ProjectTaskEditController.identity) as! ProjectTaskEditController
                controller.parentNavigationController = self.parentNavigationController
                controller.taskResource = taskResource
                controller.editResource = resource
                KRProgressHUD.dismiss()
                self.parentNavigationController?.pushViewController(controller, animated: true)
            })
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(taskEditAction)
        
        if self.taskResource?.progress == 100 && self.taskResource?.isFinish == 0 {
            let completionAction = UIAlertAction(title: trans("task.finish"), style: .default, handler: { (action: UIAlertAction) in
                KRProgressHUD.show()
                
                self.taskResource!.changeCompleteStatus(to: .completed, completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.set(duration: 2.0).dismiss({
                            KRProgressHUD.showError(withMessage: response["messages"])
                        })
                        return
                    }
                    
                    NotificationCenter.default.post(name: LocalNotificationService.taskHasUpdated, object: nil)
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                })
            })
            actionSheet.addAction(completionAction)
        }
        
        if self.taskResource?.isFinish == 1 {
            let completionAction = UIAlertAction(title: trans("task.unfinished"), style: .default, handler: { (action: UIAlertAction) in
                KRProgressHUD.show()
                self.taskResource!.changeCompleteStatus(to: .incomplete, completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.dismiss({
                            KRProgressHUD.showError(withMessage: response["messages"])
                        })
                        return
                    }
                    
                    NotificationCenter.default.post(name: LocalNotificationService.taskHasUpdated, object: nil)
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                })
            })
            actionSheet.addAction(completionAction)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func addActivity(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: false
        )
        // Add a text field
        let alert = SCLAlertView(appearance: appearance)
        let textField = alert.addTextField()
        alert.addButton(trans("task.add-comment")) {
            KRProgressHUD.show()
            
            guard let taskResource = self.taskResource else {
                KRProgressHUD.dismiss({
                    KRProgressHUD.showError(withMessage: trans("errors.network-error", option: "Network Error!"))
                })
                return
            }
            
            let activity = TaskActivityRegister(taskId: taskResource.id, content: textField.text)
            activity.store(completion: { (response) in
                guard response["status"] == "OK" else {
                    KRProgressHUD.dismiss()
                    self.showAlert(title: nil, message: response["messages"]!)
                    return
                }
                
                NotificationCenter.default.post(name: LocalNotificationService.taskActivityHasUpdated, object: nil)
                KRProgressHUD.dismiss({
                    KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                })
            })
        }
        alert.showCustom(trans("task.add-comment"),
                         subTitle: "",
                         color: Colors.themeBlue,
                         icon: UIImage(named: "task-24")!,
                         closeButtonTitle: trans("task.cancel"))
    }
    
    @IBAction func addSubTask(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: false
        )
        // Add a text field
        let alert = SCLAlertView(appearance: appearance)
        let textField = alert.addTextField()
        alert.addButton(trans("task.submit")) {
            KRProgressHUD.show()
            
            guard let taskResource = self.taskResource else {
                KRProgressHUD.dismiss({
                    KRProgressHUD.showError(withMessage: trans("errors.network-error", option: "Network Error!"))
                })
                return
            }
            
            let subTask = SubTaskRegister(taskId: taskResource.id, content: textField.text)
            subTask.store(completion: { (response) in
                guard response["status"] == "OK" else {
                    KRProgressHUD.dismiss()
                    self.showAlert(title: "error", message: response["messages"]!)
                    return
                }
                
                NotificationCenter.default.post(name: LocalNotificationService.subTaskHasUpdated, object: nil)
                KRProgressHUD.dismiss({
                    KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                })
            })
        }
        alert.showCustom(trans("task.add-sub"),
                         subTitle: "",
                         color: Colors.themeGreen,
                         icon: UIImage(named: "task-24")!,
                         closeButtonTitle: trans("task.cancel"))
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var config = UISwipeActionsConfiguration(actions: [])
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            let deleteAction = UIContextualAction(style: .normal, title: trans("task.delete")) { (_, _, completion) in
                let actionSheet = UIAlertController(title: trans("task.delete"), message: trans("task.delete-title"), preferredStyle: .actionSheet)
                
                let noAction = UIAlertAction(title: trans("task.cancel"), style: .cancel, handler: { (action: UIAlertAction) in
                    actionSheet.dismiss(animated: true, completion: nil)
                })
                
                let yesAction = UIAlertAction(title: trans("task.delete"), style: .default, handler: { (action: UIAlertAction) in
                    KRProgressHUD.show()
                    let cell = self.tableView.cellForRow(at: indexPath) as! SubTaskCell
                    let subTask = cell.subTask!
                    subTask.delete(completion: { (response) in
                        guard response["status"] == "OK" else {
                            KRProgressHUD.set(duration: 2.0).dismiss({
                                KRProgressHUD.showError(withMessage: response["messages"])
                            })
                            return
                        }
                        
                        self.taskResource?.subTasks.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        NotificationCenter.default.post(name: LocalNotificationService.subTaskHasUpdated, object: nil)
                        KRProgressHUD.dismiss({
                            KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                        })
                    })
                })
                
                actionSheet.addAction(noAction)
                actionSheet.addAction(yesAction)
                
                self.present(actionSheet, animated: true, completion: nil)
            }
            deleteAction.backgroundColor = Colors.themeMain
            config = UISwipeActionsConfiguration(actions: [deleteAction])
            break
        case 2:
            break
        default:
            break
        }
        
        return config
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.parentNavigationController?.popViewController(animated: true)
    }
}
