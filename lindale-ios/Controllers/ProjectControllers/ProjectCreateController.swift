//
//  ProjectCreateController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2019/03/15.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import MobileCoreServices

class ProjectCreateController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.setupLangLabel()
        
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    func setup() {
        self.startField.addTarget(self, action: #selector(self.startFieldEditing), for: .editingDidBegin)
        self.endField.addTarget(self, action: #selector(self.endFieldEditing), for: .editingDidBegin)
        self.navigationItem.title = trans("project.create-project")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupLangLabel() {
        self.nameField.placeholder = trans("project.title")
        self.typeField.placeholder = trans("project.type")
        self.startField.placeholder = trans("project.start_at")
        self.endField.placeholder = trans("project.end_at")
        self.passwordField.placeholder = trans("project.password")
        self.passwordConfirmationField.placeholder = trans("project.password_confirmation")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return trans("project.title")
        case 1:
            return trans("project.type")
        case 2:
            return trans("project.add-image")
        case 3:
            return trans("project.password")
        case 4:
            return trans("project.end_at")
        case 5:
            return trans("project.content")
        default:
            return nil
        }
    }
    
    @objc func startFieldEditing(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        if let date = Date.createFormFormat(string: sender.text ?? "", format: "yyyy-MM-dd") {
            datePickerView.setDate(date, animated: true)
        }
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.startFieldPickerValueChanged), for: .valueChanged)
    }
    
    @objc func startFieldPickerValueChanged(sender: UIDatePicker) {
        self.startField.text = sender.date.format("yyyy-MM-dd")
    }
    
    @objc func endFieldEditing(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        if let date = Date.createFormFormat(string: sender.text ?? "", format: "yyyy-MM-dd") {
            datePickerView.setDate(date, animated: true)
        }
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.endFieldPickerValueChanged), for: .valueChanged)
    }
    
    @objc func endFieldPickerValueChanged(sender: UIDatePicker) {
        self.endField.text = sender.date.format("yyyy-MM-dd")
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectPhotoAction = UIAlertAction(title: trans("common.choose-file"), style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: trans("errors.unauthorized"))
                })
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let takePhotoAction = UIAlertAction(title: trans("common.take-photo"), style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: trans("errors.unauthorized"))
                })
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: trans("common.cancel"), style: .cancel) { (_) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func saveButtonHasTapped(_ sender: Any) {
        let project = ProjectRegister(id: nil,
                                      title: self.nameField.text,
                                      content: self.contentField.text,
                                      startAt: self.startField.text,
                                      endAt: self.endField.text,
                                      type: self.typeField.text,
                                      SlId: nil,
                                      status: nil,
                                      password: self.passwordField.text,
                                      passwordConfirmation: self.passwordConfirmationField.text,
                                      image: self.imageView.image)
        project.store { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: nil, message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.projectHasCreated, object: nil)
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
            self.performSegue(withIdentifier: "UnwindToProjectList", sender: self)
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

extension ProjectCreateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! String
        
        guard mediaType == (kUTTypeImage as String) else {
            KRProgressHUD.set(duration: 2.0).dismiss({
                KRProgressHUD.showError(withMessage: trans("errors.not-photo"))
            })
            return
        }
        
        let image = info[.editedImage] as! UIImage
        self.imageView.image = image
        picker.dismiss(animated: true)
    }
}
