//
//  MyTaskTableViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/14.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class MyTaskTableViewController: UITableViewController {
    
    var myTaskCollection: MyTaskCollection? = MyTaskCollection.find()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup
        tableView.rowHeight = UITableView.automaticDimension
        self.setupNavigation()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        // MARK: - Notification Center Config
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.subTaskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskHasDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.localeSettingsHasUpdated, object: nil)
    }
    
    private func setupNavigation() {
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    @objc func loadData() {
        MyTaskCollection.resources { (myTaskCollection) in
            self.refreshControl?.endRefreshing()
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        KRProgressHUD.show()
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

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingTaskCell
        let task = cell.task!
        performSegue(withIdentifier: "ShowTaskDetail", sender: task)
    }
    
    @IBAction func unwindToTaskList(unwindSegue: UIStoryboardSegue) {
        print(unwindSegue)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowTaskDetail" {
            let destination = segue.destination as! MyTaskDetailController
            destination.task = sender as? MyTaskCollection.Task
        }
    }
}
