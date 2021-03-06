//
//  FoldingTodoCell.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/11/02.
//  Copyright © 2018 lindelin. All rights reserved.
//

import FoldingCell
import UIKit
import KRProgressHUD

class FoldingTodoCell: FoldingCell {
    
    var todo: Todo?
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var updateAt: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var colorBarTitle: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var contentDetail: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var initiatorName: UILabel!
    @IBOutlet weak var initiatorEmail: UILabel!
    @IBOutlet weak var statusDetail: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var list: UILabel!
    @IBOutlet weak var updateAtDetail: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    // MARK: - language label
    @IBOutlet weak var langLabelPIC: UILabel!
    @IBOutlet weak var langlabelInitator: UILabel!
    @IBOutlet weak var langLabelStatus: UILabel!
    @IBOutlet weak var langLabelType: UILabel!
    @IBOutlet weak var langLabelList: UILabel!
    @IBOutlet weak var langLabelComplete: UIButton!
    
    func setupLangLabel() {
        self.langLabelPIC.text = trans("todo.user")
        self.langlabelInitator.text = trans("todo.initiator")
        self.langLabelStatus.text = trans("todo.status")
        self.langLabelType.text = trans("todo.type")
        self.langLabelList.text = trans("todo.todo-list")
        self.langLabelComplete.setTitle(trans("status.finish"), for: .normal)
    }
    

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 5
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(todo: Todo) {
        self.setupLangLabel()
        self.todo = todo
        
        self.id.text = "#\(todo.id)"
        self.status.text = todo.status
        self.projectName.text = todo.projectName
        self.updateAt.text = todo.updatedAt
        self.contents.text = todo.content
        self.color.backgroundColor = Colors.get(id: todo.color)
        self.colorBar.backgroundColor = Colors.get(id: todo.color)
        self.colorBarTitle.text = "\(todo.projectName) #\(todo.id)"
        self.colorView.backgroundColor = Colors.get(id: todo.color)
        self.updateButton.backgroundColor = Colors.get(id: todo.color)
        self.contentDetail.text = todo.content
        self.userPhoto.load(url: todo.user?.photo, placeholder: UIImage(named: "user-30"))
        self.userName.text = todo.user?.name ?? trans("project.none")
        self.userEmail.text = todo.user?.email
        self.initiatorName.text = todo.initiator?.name
        self.initiatorEmail.text = todo.initiator?.email
        self.statusDetail.text = todo.status
        self.type.text = todo.type
        self.list.text = todo.listName
        self.updateAtDetail.text = todo.updatedAt
    }
    
    // MARK: - Actions ⚡️
    @IBAction func buttonHandler(_ sender: UIButton) {
        KRProgressHUD.show()
        
        guard let todo = self.todo else {
            KRProgressHUD.dismiss({
                KRProgressHUD.showError(withMessage: "Network Error!")
            })
            return
        }
        
        todo.complete(completion: { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: response["messages"])
                })
                return
            }
            
            NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
            
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
        })
    }
}
