//
//  ProjectTodoEditController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/26.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectTodoEditController: UITableViewController {
    
    static let identity = "ProjectTodoEdit"

    var parentNavigationController: UINavigationController?
    var cell: FoldingTodoCell!
    var editResource: Todo.EditResources!
    
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var user: UIPickerView!
    @IBOutlet weak var status: UIPickerView!
    @IBOutlet weak var color: UIPickerView!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var listPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.updateUI()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = trans("todo.edit")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let backButton = UIBarButtonItem(image: UIImage(named: "back-30"), style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        let updateButton = UIBarButtonItem(image: UIImage(named: "insert-30"), style: .plain, target: self, action: #selector(self.updateButtonTapped))
        updateButton.tintColor = Colors.themeYellow
        self.navigationItem.rightBarButtonItem = updateButton
    }
    
    func updateUI() {
        if let todo = self.cell.todo {
            self.content.text = todo.content
            for status in self.editResource.statuses {
                if status.name == todo.status {
                    self.status.selectRow(status.id - 1, inComponent: 0, animated: true)
                }
            }
            for (index, user) in self.editResource.users.enumerated() {
                if user.id == todo.user?.id {
                    self.user.selectRow(index, inComponent: 0, animated: true)
                }
            }
            self.color.selectRow(todo.color - 1 , inComponent: 0, animated: true)
            self.detail.text = todo.details ?? ""
            for (index, list) in self.editResource.lists.enumerated() {
                if list.title == todo.listName {
                    self.listPicker.selectRow(index, inComponent: 0, animated: true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return trans("todo.content")
        case 1:
            return trans("todo.user")
        case 2:
            return trans("todo.status")
        case 3:
            return trans("todo.color")
        case 4:
            return trans("todo.todo-list")
        case 5:
            return trans("todo.details")
        default:
            return nil
        }
    }
    
    @objc func updateButtonTapped() {
        if let todo = self.cell.todo {
            print(self.listPicker.selectedRow(inComponent: 0))
            print(self.editResource.lists[self.listPicker.selectedRow(inComponent: 0)].id)
            KRProgressHUD.show()
            let register = TodoRegister(id: todo.id,
                                        content: self.content.text,
                                        details: self.detail.text,
                                        statusId: self.editResource.statuses[self.status.selectedRow(inComponent: 0)].id,
                                        colorId: self.color.selectedRow(inComponent: 0) + 1,
                                        listId: self.editResource.lists[self.listPicker.selectedRow(inComponent: 0)].id,
                                        userId: self.editResource.users[self.user.selectedRow(inComponent: 0)].id,
                                        projectId: nil)
            register.update { (response) in
                guard response["status"] == "OK" else {
                    KRProgressHUD.dismiss()
                    self.showAlert(title: nil, message: response["messages"]!)
                    return
                }
                
                NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
                KRProgressHUD.dismiss({
                    KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                })
                self.parentNavigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func backButtonTapped() {
        self.parentNavigationController?.popViewController(animated: true)
    }
}

extension ProjectTodoEditController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.editResource.statuses.count
        case 2:
            return Colors.ids().count
        case 3:
            return self.editResource.users.count
        case 4:
            return self.editResource.lists.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerView.tag {
        case 1:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.themeMain,
                ]
            let string = NSAttributedString(string: self.editResource.statuses[row].name, attributes:stringAttributes)
            return string
        case 2:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.get(id: row + 1),
                ]
            let string = NSAttributedString(string: "■", attributes:stringAttributes)
            return string
        case 3:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.themeMain,
                ]
            let string = NSAttributedString(string: self.editResource.users[row].name, attributes:stringAttributes)
            return string
        case 4:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.themeMain,
                ]
            let string = NSAttributedString(string: self.editResource.lists[row].title, attributes:stringAttributes)
            return string
        default:
            return nil
        }
    }
}
