//
//  MyTaskEditViewController.swift
//  
//
//  Created by Jie Wu on 2018/11/21.
//

import UIKit
import KRProgressHUD

class MyTaskEditViewController: UITableViewController {
    
    var taskResource: TaskResource!
    var editResource: TaskResource.EditResources!

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var userPicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var taskContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.updateUI()
    }
    
    func updateUI() {
        self.taskTitle.text = self.taskResource.title
        for (index, user) in self.editResource.users.enumerated() {
            if user.id == taskResource.user?.id {
                self.userPicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        self.colorPicker.selectRow(taskResource.color - 1 , inComponent: 0, animated: true)
        self.taskContent.text = self.taskResource.content
    }

    @IBAction func updateTask(_ sender: UIBarButtonItem) {
        let user = self.editResource.users[self.userPicker.selectedRow(inComponent: 0)]
        let colorId = self.colorPicker.selectedRow(inComponent: 0) + 1
        KRProgressHUD.show(withMessage: "Updating...")
        let register = TaskRegister(id: self.taskResource.id,
                                    title: self.taskTitle.text,
                                    content: self.taskContent.text,
                                    startAt: nil,
                                    endAt: nil,
                                    cost: nil,
                                    groupId: nil,
                                    typeId: nil,
                                    userId: user.id,
                                    statusId: nil,
                                    priorityId: nil,
                                    colorId: colorId)
        register.update { (response) in
            if let response = response {
                if response["status"] == "OK" {
                    NotificationCenter.default.post(name: LocalNotificationService.taskHasUpdated, object: nil)
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                    self.navigationController?.popViewController(animated: true)
                } else {
                    KRProgressHUD.dismiss()
                    self.showAlert(title: "Update error", message: response["messages"]!)
                }
            } else {
                KRProgressHUD.dismiss({
                    KRProgressHUD.showError(withMessage: "Network Error!")
                })
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

extension MyTaskEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.editResource.users.count
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
            let string = NSAttributedString(string: self.editResource.users[row].name, attributes:stringAttributes)
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

