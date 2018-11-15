//
//  TodoEditViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/11/15.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class TodoEditViewController: UITableViewController {
    
    var cell: FoldingTodoCell!
    var editResource: Todo.EditResources!

    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var status: UIPickerView!
    @IBOutlet weak var color: UIPickerView!
    @IBOutlet weak var detail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.updateUI()
    }

    func updateUI() {
        if let todo = self.cell.todo {
            self.content.text = todo.content
            for status in self.editResource.statuses {
                if status.name == todo.status {
                    self.status.selectRow(status.id - 1, inComponent: 0, animated: true)
                }
            }
            self.color.selectRow(todo.color - 1 , inComponent: 0, animated: true)
            self.detail.text = todo.details ?? ""
        }
    }
    
    @IBAction func update(_ sender: Any) {
        if var todo = self.cell.todo {
            todo.content = self.content.text
            print(self.status.selectedRow(inComponent: 0))

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
        default:
            return nil
        }
    }
}