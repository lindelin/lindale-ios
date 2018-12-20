//
//  NotificationViewController.swift
//  lindale-task-notification-ui
//
//  Created by Jie Wu on 2018/12/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Moya

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    struct Todo: Codable {
        var id: Int
        var initiator: User?
        var content: String
        var details: String?
        var type: String
        var status: String
        var action: Int
        var color: Int
        var listName: String?
        var user: User?
        var projectName: String
        var updatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case initiator
            case content
            case details
            case type
            case status
            case action
            case color
            case listName = "list_name"
            case user
            case projectName = "project_name"
            case updatedAt = "updated_at"
        }
    }

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let taskIdKey = AnyHashable("gcm.notification.object")
        if let bbb = notification.request.content.userInfo[taskIdKey] as? String {
            let coder = JSONDecoder()
            let obj = try! coder.decode(Todo.self, from: bbb.data(using: .utf8)!)
            self.label?.text = obj.user?.name
        }
    }

}
