//
//  AccountSettingController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class AccountSettingController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.setTextFieldDelegate()
    }
    
    func setTextFieldDelegate() {
        self.password.delegate = self
        self.newPassword.delegate = self
        self.confirmPassword.delegate = self
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        KRProgressHUD.show(withMessage: "Saving...")
        let password = Settings.Password(password: self.password.text,
                                         newPassword: self.newPassword.text,
                                         newPasswordConfirmation: self.confirmPassword.text)
        password.save { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Save error", message: response["messages"]!)
                return
            }
            
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - Doneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            newPassword.becomeFirstResponder()
            break
        case 2:
            confirmPassword.becomeFirstResponder()
            break
        case 3:
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
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
