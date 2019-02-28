//
//  ProjectTodoController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import SCLAlertView
import BLTNBoard
import Down

class ProjectTodoController: UITableViewController {
    
    enum Const {
        static let closeCellHeight: CGFloat = 183
        static let openCellHeight: CGFloat = 492
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    static let identity = "ProjectTodos"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var todoCollection: TodoCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFloatyButton()
        self.setupTableView()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.todoHasUpdated, object: nil)
    }
    
    // MARK: - 弹出窗
    var bulletinManager: BLTNItemManager!
    
    private func setupFloatyButton() {
        let floaty = Floaty()
        floaty.addItem(trans("todo.add-todo-list"), icon: UIImage(named: "todo-list-30")!, handler: { item in
            let appearance = SCLAlertView.SCLAppearance(
                showCircularIcon: false
            )
            let alert = SCLAlertView(appearance: appearance)
            let textField = alert.addTextField()
            alert.addButton(trans("todo.add")) {
                KRProgressHUD.show()
                
                let todoList = TodoListRegister(id: nil,
                                                title: textField.text,
                                                projectId: self.project.id)
                todoList.store(completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.dismiss()
                        self.showAlert(title: nil, message: response["messages"]!)
                        return
                    }

                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                })
            }
            alert.showCustom(trans("todo.add-todo-list"),
                             subTitle: "",
                             color: Colors.themeBlue,
                             icon: UIImage(named: "todo-list-30")!,
                             closeButtonTitle: trans("todo.cancel"))
            floaty.close()
        })
        floaty.addItem(trans("todo.add-title"), icon: UIImage(named: "todo-30")!, handler: { item in
            let appearance = SCLAlertView.SCLAppearance(
                showCircularIcon: false
            )
            let alert = SCLAlertView(appearance: appearance)
            let textField = alert.addTextField("TODO")
            alert.addButton(trans("todo.add")) {
                KRProgressHUD.show()
                
                let todo = TodoRegister(id: nil,
                                        content: textField.text,
                                        details: nil,
                                        statusId: nil,
                                        colorId: nil,
                                        listId: nil,
                                        userId: nil,
                                        projectId: self.project.id)
                todo.store(completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.dismiss()
                        self.showAlert(title: "error", message: response["messages"]!)
                        return
                    }
                    
                    NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
                    
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                })
            }
            alert.showCustom(trans("todo.add-title"),
                             subTitle: "",
                             color: Colors.themeGreen,
                             icon: UIImage(named: "todo-30")!,
                             closeButtonTitle: trans("todo.cancel"))
            floaty.close()
        })
        floaty.sticky = true
        floaty.buttonColor = Colors.themeGreen
        floaty.plusColor = UIColor.white
        self.view.addSubview(floaty)
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
        KRProgressHUD.show()
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
        
        // MARK: - Load More Data
        if let todoCollection = self.todoCollection {
            let lastCell = todoCollection.todos.count - 1
            if lastCell == indexPath.row, let nextPage = todoCollection.links.next {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingProjectTodoCell", for: indexPath) as! FoldingTodoCell
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
    
    // MARK: - 左滑菜单
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingTodoCell
        let colorChangeActon = UIContextualAction(style: .normal, title: trans("todo.color")) { (_, _, completion) in
            let alert = SCLAlertView()
            
            for id in Colors.ids() {
                alert.addButton("", backgroundColor: Colors.get(id: id), textColor: nil, showTimeout: nil, action: {
                    KRProgressHUD.show()
                    guard let todo = cell.todo else {
                        KRProgressHUD.dismiss({
                            KRProgressHUD.showError(withMessage: "Network Error!")
                        })
                        return
                    }
                    
                    todo.changeColor(colorId: id, completion: { (response) in
                        guard response["status"] == "OK" else {
                            KRProgressHUD.set(duration: 2.0).dismiss({
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
            
            alert.showCustom("",
                             subTitle: trans("todo.color"),
                             color: Colors.get(id: cell.todo!.color),
                             icon: UIImage(),
                             closeButtonTitle: trans("todo.cancel"))
        }
        colorChangeActon.backgroundColor = Colors.get(id: cell.todo!.color)
        return UISwipeActionsConfiguration(actions: [colorChangeActon])
    }
    
    // MARK: - 右滑菜单
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // MARK: - 削除
        let deleteAction = UIContextualAction(style: .normal, title: trans("todo.delete")) { (_, _, completion) in
            let actionSheet = UIAlertController(title: nil, message: trans("todo.delete-title"), preferredStyle: .actionSheet)
            
            let noAction = UIAlertAction(title: trans("todo.cancel"), style: .cancel, handler: { (action: UIAlertAction) in
                actionSheet.dismiss(animated: true, completion: nil)
            })
            
            let yesAction = UIAlertAction(title: trans("todo.delete"), style: .default, handler: { (action: UIAlertAction) in
                KRProgressHUD.show()
                let cell = tableView.cellForRow(at: indexPath) as! FoldingTodoCell
                
                guard let todo = cell.todo else {
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showError(withMessage: "Network Error!")
                    })
                    return
                }
                
                todo.delete(completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.set(duration: 2.0).dismiss({
                            KRProgressHUD.showError(withMessage: response["messages"])
                        })
                        return
                    }
                    
                    self.todoCollection?.todos.remove(at: indexPath.row)
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
        // MARK: - 編集
        let editAction = UIContextualAction(style: .normal, title: trans("task.edit")) { (_, _, completion) in
            KRProgressHUD.show()
            let cell = self.tableView.cellForRow(at: indexPath) as! FoldingTodoCell
            Todo.EditResources.load(todo: cell.todo!, completion: { (resource) in
                KRProgressHUD.dismiss()
                if let resource = resource {
                    let storyboard = UIStoryboard(name: "ProjectTodo", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: ProjectTodoEditController.identity) as! ProjectTodoEditController
                    controller.parentNavigationController = self.parentNavigationController
                    controller.cell = cell
                    controller.editResource = resource
                    self.parentNavigationController?.pushViewController(controller, animated: true)
                }
            })
        }
        
        // MARK: - 詳細
        let detailAction = UIContextualAction(style: .normal, title: trans("todo.details")) { (_, _, completion) in
            let cell = self.tableView.cellForRow(at: indexPath) as! FoldingTodoCell
            self.bulletinManager = {
                let page = BLTNPageItem(title: trans("todo.details"))
                if let content = cell.todo?.details {
                    let md = Down(markdownString: content)
                    page.attributedDescriptionText = try? md.toAttributedString()
                } else {
                    page.descriptionText = trans("project.none")
                }
                let rootItem: BLTNItem = page
                return BLTNItemManager(rootItem: rootItem)
            }()
            self.bulletinManager.showBulletin(above: self)
        }
        
        detailAction.backgroundColor = Colors.themeBase
        editAction.backgroundColor = Colors.themeYellow
        deleteAction.backgroundColor = Colors.themeMain
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, detailAction])
    }
}
