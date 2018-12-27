//
//  MyTodoTableViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/15.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import SCLAlertView

class MyTodoTableViewController: UITableViewController {
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    var myTodoCollection: MyTodoCollection? = MyTodoCollection.find()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupNavigation()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.todoHasUpdated, object: nil)
    }
    
    private func setupNavigation() {
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    private func setupTableView() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: (self.myTodoCollection?.todos.count) ?? Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    @objc func loadData() {
        MyTodoCollection.resources { (myTodoCollection) in
            self.refreshControl?.endRefreshing()
            
            guard let myTodoCollection = myTodoCollection else {
                self.authErrorHandle()
                return
            }
            
            self.myTodoCollection = myTodoCollection
            self.updateUI()
        }
    }
    
    func updateUI() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: (self.myTodoCollection?.todos.count) ?? Const.rowsCount)
        self.tableView.reloadData()
    }
    
    func loadMoreData(url: URL) {
        KRProgressHUD.show(withMessage: "Loding...")
        MyTodoCollection.more(nextUrl: url) { (myTodoCollection) in
            if let myTodoCollection = myTodoCollection {
                self .myTodoCollection?.links = myTodoCollection.links
                self .myTodoCollection?.meta = myTodoCollection.meta
                self .myTodoCollection?.todos.append(contentsOf: myTodoCollection.todos)
                self.updateUI()
                KRProgressHUD.dismiss()
            }
        }
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
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let myTodoCollection = self.myTodoCollection {
            let lastCell = myTodoCollection.todos.count - 1
            if lastCell == indexPath.row {
                guard let nextPage = myTodoCollection.links.next else {
                    return
                }
                self.loadMoreData(url: nextPage)
            }
        }
        
        guard case let cell as FoldingTodoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingTodoCell", for: indexPath) as! FoldingTodoCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.setCell(todo: self.myTodoCollection!.todos[indexPath.row])
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingTodoCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    // MARK: - 左滑菜单
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingTodoCell
        let colorChangeActon = UIContextualAction(style: .normal, title: "Color") { (_, _, completion) in
            let alert = SCLAlertView()
            
            for id in Colors.ids() {
                alert.addButton("", backgroundColor: Colors.get(id: id), textColor: nil, showTimeout: nil, action: {
                    KRProgressHUD.show(withMessage: "Updating...")
                    guard let todo = cell.todo else {
                        KRProgressHUD.dismiss({
                            KRProgressHUD.showError(withMessage: "Network Error!")
                        })
                        return
                    }
                    
                    todo.changeColor(colorId: id, completion: { (response) in
                        guard response["status"] == "OK" else {
                            KRProgressHUD.dismiss({
                                KRProgressHUD.showError(withMessage: response["messages"])
                            })
                            return
                        }
                        
                        NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
                        KRProgressHUD.dismiss({
                            KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                        })
                    })
                })
            }
            
            alert.showCustom("カラー変更",
                             subTitle: "カラーを選んでください。",
                             color: Colors.get(id: cell.todo!.color),
                             icon: UIImage(),
                             closeButtonTitle: "取消")
        }
        colorChangeActon.backgroundColor = Colors.get(id: cell.todo!.color)
        return UISwipeActionsConfiguration(actions: [colorChangeActon])
    }
    
    // MARK: - 右滑菜单
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, completion) in
            let actionSheet = UIAlertController(title: "削除", message: "TODOを削除しますか？", preferredStyle: .actionSheet)
            
            let noAction = UIAlertAction(title: "いいえ", style: .cancel, handler: { (action: UIAlertAction) in
                actionSheet.dismiss(animated: true, completion: nil)
            })
            
            let yesAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction) in
                KRProgressHUD.show(withMessage: "Deleting...")
                let cell = tableView.cellForRow(at: indexPath) as! FoldingTodoCell
                
                guard let todo = cell.todo else {
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showError(withMessage: "Network Error!")
                    })
                    return
                }
                
                todo.delete(completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.dismiss({
                            KRProgressHUD.showError(withMessage: response["messages"])
                        })
                        return
                    }
                    
                    self.myTodoCollection?.todos.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                })
            })
            
            actionSheet.addAction(noAction)
            actionSheet.addAction(yesAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        // TODO: - 代码优化
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completion) in
            let cell = self.tableView.cellForRow(at: indexPath) as! FoldingTodoCell
            Todo.EditResources.load(todo: cell.todo!, completion: { (resource) in
                if let resource = resource {
                    self.performSegue(withIdentifier: "TodoEditSegue", sender: ["cell": cell, "resource": resource])
                }
            })
        }
        
        editAction.backgroundColor = Colors.themeYellow
        deleteAction.backgroundColor = Colors.themeMain
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    // MARK: - Navigation
    @IBAction func unwindToTodoList(unwindSegue: UIStoryboardSegue) {
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoEditSegue" {
            let destination = segue.destination as! UINavigationController
            let todoEditViewController = destination.viewControllers.first as! TodoEditViewController
            
            guard let sender = sender as? Dictionary<String, Any> else {
                return
            }
            
            todoEditViewController.cell = sender["cell"] as? FoldingTodoCell
            todoEditViewController.editResource = sender["resource"] as? Todo.EditResources
        }
    }
}
