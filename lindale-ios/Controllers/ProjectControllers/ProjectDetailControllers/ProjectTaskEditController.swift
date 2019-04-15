//
//  ProjectTaskEditController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/27.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectTaskEditController: UITableViewController {
    
    static let identity = "ProjectTaskEdit"

    var parentNavigationController: UINavigationController?
    var taskResource: TaskResource!
    var editResource: TaskResource.EditResources!
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var startAt: UITextField!
    @IBOutlet weak var endAt: UITextField!
    @IBOutlet weak var userPicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var taskContent: UITextView!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var cost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupLangLabel()
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.updateUI()
    }
    
    func setup() {
        self.startAt.addTarget(self, action: #selector(self.startAtEditing), for: .editingDidBegin)
        self.endAt.addTarget(self, action: #selector(self.endAtEditing), for: .editingDidBegin)
        self.navigationItem.title = trans("task.edit-task")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupLangLabel() {
        self.taskTitle.placeholder = trans("task.task-title")
        self.startAt.placeholder = trans("task.start_at")
        self.endAt.placeholder = trans("task.end_at")
        self.cost.placeholder = trans("task.cost")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return trans("task.group")
        case 1:
            return trans("task.type")
        case 2:
            return trans("task.task-title")
        case 3:
            return trans("task.end_at")
        case 4:
            return trans("task.cost")
        case 5:
            return trans("task.user")
        case 6:
            return trans("task.color")
        case 7:
            return trans("task.info")
        default:
            return nil
        }
    }
    
    func updateUI() {
        self.taskTitle.text = self.taskResource.title
        self.startAt.text = Date.createFormFormat(string: self.taskResource.startAt ?? "")?.format("yyyy-MM-dd")
        self.endAt.text = Date.createFormFormat(string: self.taskResource.endAt ?? "")?.format("yyyy-MM-dd")
        
        if let index = self.editResource.users.firstIndex(where: {$0.id == self.taskResource.user?.id}) {
            self.userPicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        if let index = self.editResource.groups.firstIndex(where: {$0.id == self.taskResource.groupId}) {
            self.groupPicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        if let index = self.editResource.types.firstIndex(where: {$0.id == self.taskResource.typeId}) {
            self.typePicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        self.colorPicker.selectRow(taskResource.color - 1 , inComponent: 0, animated: true)
        self.taskContent.text = self.taskResource.content
        self.cost.text = self.taskResource.cost.description
    }
    
    @IBAction func updateTask(_ sender: UIBarButtonItem) {
        let user = self.editResource.users[self.userPicker.selectedRow(inComponent: 0)]
        let group = self.editResource.groups[self.groupPicker.selectedRow(inComponent: 0)]
        let type = self.editResource.types[self.typePicker.selectedRow(inComponent: 0)]
        let colorId = self.colorPicker.selectedRow(inComponent: 0) + 1
        KRProgressHUD.show()
        let register = TaskRegister(id: self.taskResource.id,
                                    title: self.taskTitle.text,
                                    content: self.taskContent.text,
                                    startAt: self.startAt.text,
                                    endAt: self.endAt.text,
                                    cost: Int(self.cost.text ?? "0"),
                                    groupId: group.id,
                                    typeId: type.id,
                                    userId: user.id,
                                    statusId: nil,
                                    priorityId: nil,
                                    colorId: colorId,
                                    projectId: nil)
        register.update { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: nil, message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.taskHasUpdated, object: nil)
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
            self.parentNavigationController?.popViewController(animated: true)
        }
    }
    
    @objc func startAtEditing(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        if let date = Date.createFormFormat(string: sender.text ?? "", format: "yyyy-MM-dd") {
            datePickerView.setDate(date, animated: true)
        }
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.startAtPickerValueChanged), for: .valueChanged)
    }
    
    @objc func startAtPickerValueChanged(sender: UIDatePicker) {
        self.startAt.text = sender.date.format("yyyy-MM-dd")
    }
    
    @objc func endAtEditing(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        if let date = Date.createFormFormat(string: sender.text ?? "", format: "yyyy-MM-dd") {
            datePickerView.setDate(date, animated: true)
        }
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.endAtPickerValueChanged), for: .valueChanged)
    }
    
    @objc func endAtPickerValueChanged(sender: UIDatePicker) {
        self.endAt.text = sender.date.format("yyyy-MM-dd")
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.parentNavigationController?.popViewController(animated: true)
    }
}

extension ProjectTaskEditController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.editResource.users.count
        case 2:
            return Colors.ids().count
        case 3:
            return self.editResource.groups.count
        case 4:
            return self.editResource.types.count
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
            let string = NSAttributedString(string: self.editResource.users[row].name, attributes:stringAttributes)
            return string
        case 2:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.get(id: row + 1),
                ]
            let string = NSAttributedString(string: "■", attributes:stringAttributes)
            return string
        case 3:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.get(id: self.editResource.groups[row].color),
                ]
            let string = NSAttributedString(string: self.editResource.groups[row].title, attributes:stringAttributes)
            return string
        case 4:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.get(id: self.editResource.types[row].colorId),
                ]
            let string = NSAttributedString(string: self.editResource.types[row].name, attributes:stringAttributes)
            return string
        default:
            return nil
        }
    }
}
