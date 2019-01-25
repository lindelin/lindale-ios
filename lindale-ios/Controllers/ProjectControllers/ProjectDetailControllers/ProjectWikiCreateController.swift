//
//  ProjectWikiCreateController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2019/01/25.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import MobileCoreServices

class ProjectWikiCreateController: UITableViewController {
    
    static let identity = "ProjectWikiCreate"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var wikiTypes: [WikiType]!
    var selectedIndex: WikiType?
    
    @IBOutlet weak var indexLabel: UITextField!
    @IBOutlet weak var wikiTitle: UITextField!
    @IBOutlet weak var wikiContent: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        self.setup()
        self.setupNavigation()
        self.updateUI()
    }
    
    func setup() {
        self.indexLabel.addTarget(self, action: #selector(self.indexEditing), for: .editingDidBegin)
    }
    
    @objc func indexEditing(sender: UITextField) {
        let picker = UIPickerView()
        picker.tag = 0
        picker.dataSource = self
        picker.delegate = self
        sender.inputView = picker
    }
    
    func updateUI() {
        if let index = self.selectedIndex {
            self.indexLabel.text = index.name
        }
    }
    
    private func setupNavigation() {
        self.navigationItem.title = trans("wiki.submit")
        let backButton = UIBarButtonItem(image: UIImage(named: "back-30"), style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        let updateButton = UIBarButtonItem(image: UIImage(named: "insert-30"), style: .plain, target: self, action: #selector(self.updateButtonTapped))
        updateButton.tintColor = Colors.themeYellow
        self.navigationItem.rightBarButtonItem = updateButton
    }
    
    @objc func backButtonTapped() {
        self.parentNavigationController?.popViewController(animated: true)
    }
    
    @objc func updateButtonTapped() {
        KRProgressHUD.show()
        let register = WikiRegister(id: nil,
                                    title: self.wikiTitle.text,
                                    content: self.wikiContent.text,
                                    typeId: self.selectedIndex?.id,
                                    image: self.image.image,
                                    projectId: self.project.id)
        register.store { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: nil, message: response["messages"]!)
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.wikiHasUpdated, object: nil)
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
            
            self.parentNavigationController?.popViewController(animated: true)
        }
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
}

extension ProjectWikiCreateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! String
        
        guard mediaType == (kUTTypeImage as String) else {
            KRProgressHUD.set(duration: 2.0).dismiss({
                KRProgressHUD.showError(withMessage: trans("errors.not-photo"))
            })
            return
        }
        
        let image = info[.originalImage] as! UIImage
        self.image.image = image
        picker.dismiss(animated: true)
    }
}

extension ProjectWikiCreateController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return self.wikiTypes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerView.tag {
        case 0:
            let stringAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : Colors.themeMain,
                ]
            let string = NSAttributedString(string: self.wikiTypes[row].name, attributes:stringAttributes)
            return string
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = self.wikiTypes[row]
        self.indexLabel.text = self.selectedIndex?.name
    }
}
