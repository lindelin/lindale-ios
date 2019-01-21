//
//  TaskGroupEditController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2019/01/21.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit

class TaskGroupEditController: UITableViewController {
    
    static let identity = "ProjectTaskGroupEdit"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var taskGroup: TaskGroup!
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
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.updateUI()
    }
    
    func setup() {
        self.startAt.addTarget(self, action: #selector(self.startAtEditing), for: .editingDidBegin)
        self.endAt.addTarget(self, action: #selector(self.endAtEditing), for: .editingDidBegin)
    }
    
    func updateUI() {
        self.groupName.text = self.taskGroup.title
        self.startAt.text = Date.createFormFormat(string: self.taskGroup.startAt ?? "")?.format("yyyy-MM-dd")
        self.endAt.text = Date.createFormFormat(string: self.taskGroup.endAt ?? "")?.format("yyyy-MM-dd")
        for (index, type) in self.editResource.types.enumerated() {
            if type.name == self.taskGroup.type {
                self.type.selectRow(index, inComponent: 0, animated: true)
            }
        }
        self.color.selectRow(self.taskGroup.color - 1 , inComponent: 0, animated: true)
        self.status.selectedSegmentIndex = self.taskGroup.isOpen() ? 0 : 1
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
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
}

extension TaskGroupEditController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
