//
//  MyTaskTableViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/14.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class MyTaskTableViewController: UITableViewController {
    
    var myTaskCollection: MyTaskCollection? = MyTaskCollection.find()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.updateUI()
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.subTaskHasUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.taskHasUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    @objc func loadData() {
        MyTaskCollection.resources { (myTaskCollection) in
            if let myTaskCollection = myTaskCollection {
                self.myTaskCollection = myTaskCollection
                self.updateUI()
            } else {
                self.authErrorHandle()
            }
            self.refreshControl?.endRefreshing()
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: DefaultTaskCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! DefaultTaskCell
        
        cell.setCell(task: (self.myTaskCollection?.tasks[indexPath.row])!)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowTaskDetail" {
            let row = tableView.indexPathForSelectedRow!
            let cell = tableView.cellForRow(at: row) as! DefaultTaskCell
            let destination = segue.destination as! MyTaskDetailController
            destination.task = cell.task!
        }
    }
}
