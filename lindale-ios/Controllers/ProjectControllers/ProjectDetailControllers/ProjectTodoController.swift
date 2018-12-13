//
//  ProjectTodoController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectTodoController: UITableViewController {
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    static let identity = "ProjectTodos"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var todoCollection: TodoCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
    }
    
    private func setupTableView() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: (self.todoCollection?.todos.count) ?? Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    @objc func loadData() {
        TodoCollection.resources(project: self.project) { (todoCollection) in
            self.refreshControl?.endRefreshing()
            
            guard let todoCollection = todoCollection else {
                self.authErrorHandle()
                return
            }
            
            self.todoCollection = todoCollection
            self.updateUI()
        }
    }
    
    func updateUI() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: (self.todoCollection?.todos.count) ?? Const.rowsCount)
        self.tableView.reloadData()
    }
    
    func loadMoreData(url: URL) {
        KRProgressHUD.show(withMessage: "Loding...")
        TodoCollection.more(nextUrl: url) { (todoCollection) in
            if let todoCollection = todoCollection {
                self .todoCollection?.links = todoCollection.links
                self .todoCollection?.meta = todoCollection.meta
                self .todoCollection?.todos.append(contentsOf: todoCollection.todos)
                self.updateUI()
                KRProgressHUD.dismiss()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.todoCollection?.todos.count) ?? 0
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let todoCollection = self.todoCollection {
            let lastCell = todoCollection.todos.count - 1
            if lastCell == indexPath.row {
                guard let nextPage = todoCollection.links.next else {
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
        cell.setCell(todo: self.todoCollection!.todos[indexPath.row])
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
