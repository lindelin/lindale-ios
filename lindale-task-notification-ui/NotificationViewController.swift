//
//  NotificationViewController.swift
//  lindale-task-notification-ui
//
//  Created by Jie Wu on 2018/12/25.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    var task: Task?

    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var projectNameAndCode: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var subTaskStatus: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var initiatorName: UILabel!
    @IBOutlet weak var initiatorEmail: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var endAt: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    
    struct Task: Codable {
        var projectName: String
        var id: Int
        var initiator: User?
        var title: String
        var content: String?
        var startAt: String?
        var endAt: String?
        var cost: Int
        var progress: Int
        var user: User?
        var color: Int
        var type: String
        var status: String
        var subTaskStatus: String
        var group: String?
        var priority: String
        var isFinish: Int
        var updatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case projectName = "project_name"
            case id
            case initiator
            case title
            case content
            case startAt = "start_at"
            case endAt = "end_at"
            case cost
            case progress
            case user
            case color
            case type
            case status
            case subTaskStatus = "sub_task_status"
            case group
            case priority
            case isFinish = "is_finish"
            case updatedAt = "updated_at"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            guard let data = (userInfo["gcm.notification.object"] as? String)?.data(using: .utf8) else {
                return
            }
            
            guard let task = try? JSONDecoder.main.decode(Task.self, from: data) else {
                return
            }
            
            self.updateUI(with: task)
        }
    }
    
    func updateUI(with task: Task) {
        self.task = task
        self.colorBar.backgroundColor = Colors.get(id: task.color)
        self.projectNameAndCode.text = "\(task.projectName) #\(task.id)"
        self.taskTitle.text = "\(task.type): \(task.title)"
        self.progressBar.progress = Float(Double(task.progress) / Double(100))
        self.progressBar.progressTintColor = Colors.get(id: task.color)
        self.subTaskStatus.text = task.subTaskStatus
        self.userPhoto.load(url: task.user?.photo, placeholder: UIImage(named: "user-30"))
        self.userName.text = task.user?.name
        self.userEmail.text = task.user?.email
        self.initiatorName.text = task.initiator?.name
        self.initiatorEmail.text = task.initiator?.email
        self.status.text = task.status
        self.priority.text = task.priority
        self.group.text = task.group ?? "N/A"
        self.startAt.text = task.startAt ?? "N/A"
        self.endAt.text = task.endAt ?? "N/A"
        self.updatedAt.text = task.updatedAt
    }

}

