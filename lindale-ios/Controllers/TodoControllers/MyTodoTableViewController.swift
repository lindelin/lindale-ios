//
//  MyTodoTableViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/15.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class MyTodoTableViewController: UITableViewController {
    
    var myTodoCollection: MyTodoCollection? = MyTodoCollection.find()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        self.tableView.reloadData()
    }
    
    @objc func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MyTodoCollection.resources { (myTodoCollection) in
            if let myTodoCollection = myTodoCollection {
                self.updateUI(with: myTodoCollection)
                self.refreshControl?.endRefreshing()
            } else {
                //self.logout()
            }
        }
    }
    
    func updateUI(with myTodoCollection: MyTodoCollection) {
        self.myTodoCollection = myTodoCollection
        self.tableView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.myTodoCollection?.todos.count) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: DefaultTodoCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! DefaultTodoCell
        
        cell.setCell(todo: (self.myTodoCollection?.todos[indexPath.row])!)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
