//
//  TaskGroupEditController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2019/01/21.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class TaskGroupCreateController: UITableViewController {
    
    static let identity = "ProjectTaskGroupCreate"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var editResource: TaskGroup.EditResources!
    
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var startAt: UITextField!
    @IBOutlet weak var endAt: UITextField!
    @IBOutlet weak var type: UIPickerView!
    @IBOutlet weak var status: UISegmentedControl!
    @IBOutlet weak var color: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupLangLabel()
        
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    func setup() {
        self.startAt.addTarget(self, action: #selector(self.startAtEditing), for: .editingDidBegin)
        self.endAt.addTarget(self, action: #selector(self.endAtEditing), for: .editingDidBegin)
        self.navigationItem.title = trans("task.new-group")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupLangLabel() {
        self.groupName.placeholder = trans("task.group-title")
        self.startAt.placeholder = trans("task.start_at")
        self.endAt.placeholder = trans("task.end_at")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return trans("task.group-title")
        case 1:
            return trans("task.end_at")
        case 2:
            return trans("task.type")
        case 3:
            return trans("task.status")
        case 4:
            return trans("task.color")
        default:
            return nil
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        KRProgressHUD.show()
        let type = self.editResource.types[self.type.selectedRow(inComponent: 0)]
        let statusId = TaskGroup.Status.open.rawValue
        let colorId = self.color.selectedRow(inComponent: 0) + 1
        let register = TaskGroupRegister(id: nil,
                                         title: self.groupName.text,
                                         information: nil,
                                         typeId: type.id,
                                         statusId: statusId,
                                         startAt: self.startAt.text,
                                         endAt: self.endAt.text,
                                         colorId: colorId,
                                         projectId: self.project.id)
        register.store { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: nil, message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.taskGroupHasUpdated, object: nil)
            
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

extension TaskGroupCreateController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.editResource.types.count
        case 2:
            return Colors.ids().count
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
            let string = NSAttributedString(string: self.editResource.types[row].name, attributes:stringAttributes)
            return string
        case 2:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.get(id: row + 1),
                ]
            let string = NSAttributedString(string: "■", attributes:stringAttributes)
            return string
        default:
            return nil
        }
    }
}
