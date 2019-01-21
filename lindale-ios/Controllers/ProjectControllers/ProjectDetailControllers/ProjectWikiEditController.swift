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
        self.navigationItem.title = "Edit"
        let backButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        let updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(self.updateButtonTapped))
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
        KRProgressHUD.show(withMessage: "Updating...")
        let register = WikiRegister(id: self.wiki.id,
                                    title: self.wikiTitle.text,
                                    content: self.wikiContent.text,
                                    typeId: nil,
                                    image: self.image.image)
        register.update { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Update error", message: response["messages"]!)
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
        
        let selectPhotoAction = UIAlertAction(title: "写真を選択", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: "写真を取得する権利がありません。")
                })
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let takePhotoAction = UIAlertAction(title: "カメラで撮影", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: "カメラを利用する権利がありません。")
                })
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
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

extension ProjectWikiEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! String
        
        guard mediaType == (kUTTypeImage as String) else {
            KRProgressHUD.set(duration: 2.0).dismiss({
                KRProgressHUD.showError(withMessage: "写真を選択してください。")
            })
            return
        }
        
        let image = info[.originalImage] as! UIImage
        self.image.image = image
        picker.dismiss(animated: true)
    }
}

