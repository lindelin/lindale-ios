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
        self.setup()
        self.setTextFieldDelegate()
        self.setupLangLabel()
    }
    
    func setup() {
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = trans("user.account")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setTextFieldDelegate() {
        self.password.delegate = self
        self.newPassword.delegate = self
        self.confirmPassword.delegate = self
    }
    
    func setupLangLabel() {
        self.password.placeholder = trans("auth.password")
        self.newPassword.placeholder = trans("auth.set")
        self.confirmPassword.placeholder = trans("auth.confirm_password")
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        KRProgressHUD.show()
        let password = Settings.Password(password: self.password.text,
                                         newPassword: self.newPassword.text,
                                         newPasswordConfirmation: self.confirmPassword.text)
        password.save { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: nil, message: response["messages"]!)
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

    // MARK: - Navigation

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
