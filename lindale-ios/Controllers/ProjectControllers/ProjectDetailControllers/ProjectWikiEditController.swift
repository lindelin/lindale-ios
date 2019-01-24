//
//  ProjectWikiEditController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/26.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import MobileCoreServices

class ProjectWikiEditController: UITableViewController {

    static let identity = "ProjectWikiEdit"
    
    var parentNavigationController: UINavigationController?
    var wiki: Wiki!
    
    @IBOutlet weak var wikiTitle: UITextField!
    @IBOutlet weak var wikiContent: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        self.setupNavigation()
        self.updateUI()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = trans("wiki.edit-title")
        let backButton = UIBarButtonItem(image: UIImage(named: "back-30"), style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        let updateButton = UIBarButtonItem(image: UIImage(named: "insert-30"), style: .plain, target: self, action: #selector(self.updateButtonTapped))
        updateButton.tintColor = Colors.themeYellow
        self.navigationItem.rightBarButtonItem = updateButton
    }
    
    func updateUI() {
        self.wikiTitle.text = self.wiki.title
        self.wikiContent.text = self.wiki.originalContent
    }
    
    @objc func backButtonTapped() {
        self.parentNavigationController?.popViewController(animated: true)
    }
    
    @objc func updateButtonTapped() {
        KRProgressHUD.show()
        let register = WikiRegister(id: self.wiki.id,
                                    title: self.wikiTitle.text,
                                    content: self.wikiContent.text,
                                    typeId: nil,
                                    image: self.image.image)
        register.update { (response) in
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

extension ProjectWikiEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

