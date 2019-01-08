//
//  ProjectGroupTasksController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/27.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectGroupTasksController: UITableViewController {
    
    static let identity = "ProjectGroupTasks"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var taskGroup: TaskGroup!
    var myTaskCollection: MyTaskCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFloatyButton()

        // MARK: - Setup
        tableView.rowHeight = UITableView.automaticDimension
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        // MARK: - Notification Center Config
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.subTaskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskHasDeleted, object: nil)
    }
    
    private func setupFloatyButton() {
        let floaty = Floaty()
        floaty.addItem("New Group", icon: UIImage(named: "task-group-30")!, handler: { item in
            // TODO
            floaty.close()
        })
        floaty.addItem("New Task", icon: UIImage(named: "task-30")!, handler: { item in
            // TODO
            floaty.close()
        })
        floaty.sticky = true
        floaty.buttonColor = Colors.themeGreen
        floaty.plusColor = UIColor.white
        floaty.paddingY = Size.tabBarHeight + 14
        self.view.addSubview(floaty)
    }
    
    @objc func loadData() {
        KRProgressHUD.show(withMessage: "Loding...")
        MyTaskCollection.resources(group: self.taskGroup) { (myTaskCollection) in
            self.refreshControl?.endRefreshing()
            KRProgressHUD.dismiss()
            
            guard let myTaskCollection = myTaskCollection else {
                self.authErrorHandle()
                return
            }
            
            self.myTaskCollection = myTaskCollection
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.myTaskCollection?.tasks.count) ?? 0
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 518
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: FoldingTaskCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! FoldingTaskCell
        
        cell.backgroundColor = .clear
        
        cell.setCell(task: (self.myTaskCollection?.tasks[indexPath.row])!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myTaskCollection = self.myTaskCollection {
            let lastCell = myTaskCollection.tasks.count - 1
            if lastCell == indexPath.row {
                guard let nextPage = myTaskCollection.links.next else {
                    return
                }
                self.loadMoreData(url: nextPage)
            }
        }
    }
    
    func loadMoreData(url: URL) {
        KRProgressHUD.show(withMessage: "Loding...")
        MyTaskCollection.more(nextUrl: url) { (myTaskCollection) in
            if let myTaskCollection = myTaskCollection {
                self .myTaskCollection?.links = myTaskCollection.links
                self .myTaskCollection?.meta = myTaskCollection.meta
                self .myTaskCollection?.tasks.append(contentsOf: myTaskCollection.tasks)
                self.updateUI()
                KRProgressHUD.dismiss()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingTaskCell
        let storyboard = UIStoryboard(name: "ProjectTask", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ProjectTaskDetailController.identity) as! ProjectTaskDetailController
        controller.parentNavigationController = self.parentNavigationController
        controller.project = self.project
        controller.task = cell.task
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
