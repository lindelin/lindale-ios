//
//  TodoEditViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/11/15.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class TodoEditViewController: UITableViewController {
    
    var cell: FoldingTodoCell!
    var editResource: Todo.EditResources!

    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var user: UIPickerView!
    @IBOutlet weak var status: UIPickerView!
    @IBOutlet weak var color: UIPickerView!
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupLangLabel()
        
        self.updateUI()
    }
    
    func setup() {
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = trans("todo.edit")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupLangLabel() {
        self.content.placeholder = trans("todo.content")
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
            return trans("todo.details")
        default:
            return nil
        }
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
                    self.user.selectRow(index + 1, inComponent: 0, animated: true)
                }
            }
            self.color.selectRow(todo.color - 1 , inComponent: 0, animated: true)
            self.detail.text = todo.details ?? ""
        }
    }
    
    @IBAction func update(_ sender: Any) {
        if let todo = self.cell.todo {
            KRProgressHUD.show()
            let userId = self.user.selectedRow(inComponent: 0) == 0 ? nil : self.editResource.users[self.user.selectedRow(inComponent: 0)].id
            let register = TodoRegister(id: todo.id,
                                        content: self.content.text,
                                        details: self.detail.text,
                                        statusId: self.editResource.statuses[self.status.selectedRow(inComponent: 0)].id,
                                        colorId: self.color.selectedRow(inComponent: 0) + 1,
                                        listId: nil,
                                        userId: userId,
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
                self.performSegue(withIdentifier: "UnwindToTodoList", sender: self)
            }
        }
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

extension TodoEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            return self.editResource.users.count + 1
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
            let string = NSAttributedString(string: row == 0 ? "--" : self.editResource.users[row - 1].name, attributes:stringAttributes)
            return string
        default:
            return nil
        }
    }
}
