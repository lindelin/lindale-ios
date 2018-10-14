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
        self.setUp()
        self.loadData()
        
        self.headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(self.headerView)
        tableView.contentInset = UIEdgeInsets(top: 146, left: 0, bottom: 0, right: 0)
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.searchController = UISearchController(searchResultsController: nil)
//        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.subTaskHasUpdated, object: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        headerView.frame = CGRect(x: 0, y: offsetY, width: scrollView.bounds.width, height: 252)
    }
    
    func setUp() {
        self.taskProgress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        self.taskTitle.text = "\(self.task.type): \(self.task.title)"
        self.taskTitle.textColor = Colors.get(id: self.task.color)
        self.taskType.text = "\(self.task.projectName): #\(self.task.id.description)"
        self.taskType.textColor = Colors.get(id: self.task.color)
        self.taskProgress.progress = Float(Double(self.task.progress) / Double(100))
        self.taskProgress.progressTintColor = Colors.get(id: self.task.color)
    }
    
    @objc func loadData() {
        TaskResource.load(id: self.task.id) { (taskResource) in
            if let taskResource = taskResource {
                self.taskResource = taskResource
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
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
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
//        -> String? {
//            
//            var title = ""
//            
//            switch segmentedControl.selectedSegmentIndex {
//            case 0:
//                title = self.getOverviewSectionTitle(section: section)
//                break
//            case 1:
//                title = "サブチケット"
//                break
//            case 2:
//                title = "アクティビティ"
//                break
//            default:
//                break
//            }
//            
//            return title
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var cellCount = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cellCount = 1
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
            cell = sectionCell
            break
        case 2:
            let id = String(describing: TaskBasicInfoCell.self)
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskBasicInfoCell
            if let taskResource = self.taskResource {
                sectionCell.setCell(taskResource: taskResource)
            } else {
                sectionCell.setCell(task: self.task)
            }
            cell = sectionCell
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
    
    func getOverviewSectionTitle(section: Int) -> String {
        var title = ""
        
        switch section {
        case 0:
            title = "担当者"
            break
        case 1:
            title = "起票者"
            break
        case 2:
            title = "情報"
            break
        case 3:
            title = "説明"
            break
        default:
            break
        }
        
        return title
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
