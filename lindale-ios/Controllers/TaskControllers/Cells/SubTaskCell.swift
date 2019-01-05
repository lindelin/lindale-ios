//
//  SubTaskCell.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class SubTaskCell: UITableViewCell {
    
    var subTask: TaskResource.SubTask?
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var completeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(subTask: TaskResource.SubTask) {
        self.subTask = subTask
        self.content.text = subTask.content
        if subTask.isCompleted() {
            self.content.textColor = Colors.themeBaseSub
        } else {
            self.content.textColor = Colors.themeMain
        }
        self.completeSwitch.isOn = subTask.isCompleted()
    }
    
    @IBAction func completeSwitchChanged(_ sender: UISwitch) {
        KRProgressHUD.show(withMessage: "Updating...")
        
        if sender.isOn {
            self.subTask!.isFinish = TaskResource.SubTask.on
            self.content.textColor = Colors.themeBaseSub
        } else {
            self.subTask!.isFinish = TaskResource.SubTask.off
            self.content.textColor = Colors.themeMain
        }
        
        self.subTask!.update { (response) in
            NotificationCenter.default.post(name: LocalNotificationService.subTaskHasUpdated, object: nil)
            
            guard response["status"] == "OK" else {
                KRProgressHUD.set(duration: 2.0).dismiss({
                    KRProgressHUD.showError(withMessage: response["messages"])
                })
                return
            }
            
            KRProgressHUD.dismiss({
                KRProgressHUD.showSuccess(withMessage: response["messages"]!)
            })
        }
    }
}
