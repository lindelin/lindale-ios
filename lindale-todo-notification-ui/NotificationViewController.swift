//
//  NotificationViewController.swift
//  lindale-todo-notification-ui
//
//  Created by Jie Wu on 2018/12/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Moya

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    var todo: Todo?
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var contentDetail: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var initiatorName: UILabel!
    @IBOutlet weak var initiatorEmail: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var list: UILabel!
    @IBOutlet weak var updateAtDetail: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
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
        
        func complete(completion: @escaping ([String: String]) -> Void) {
            NetworkProvider.main.message(request: .updateTodoToFinished(todo: self)) { (status) in
                completion(status)
            }
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
            
            guard let todo = try? JSONDecoder.main.decode(Todo.self, from: data) else {
                return
            }
            
            self.updateUI(with: todo)
        }
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        if let todo = self.todo {
            self.updateButton.setTitle("Updating...", for: .normal)
            todo.complete { (response) in
                guard response["status"] == "OK" else {
                    self.updateButton.setTitle(response["messages"], for: .normal)
                    return
                }
                
                self.updateButton.setTitle(response["messages"], for: .normal)
                self.updateButton.isEnabled = false
            }
        }
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        completion(.doNotDismiss)
    }
    
    func updateUI(with todo: Todo) {
        self.todo = todo
        self.status.text = todo.status
        self.projectName.text = "\(todo.projectName) #\(todo.id)"
        self.colorBar.backgroundColor = Colors.get(id: todo.color)
        self.updateButton.backgroundColor = Colors.get(id: todo.color)
        self.contentDetail.text = todo.content
        self.userPhoto.load(url: todo.user?.photo, placeholder: UIImage(named: "user-30"))
        self.userName.text = todo.user?.name
        self.userEmail.text = todo.user?.email
        self.initiatorName.text = todo.initiator?.name
        self.initiatorEmail.text = todo.initiator?.email
        self.type.text = todo.type
        self.list.text = todo.listName
        self.updateAtDetail.text = todo.updatedAt
    }
}

extension UIImageView {
    func load(url: URL?, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        
        guard let url = url else {
            self.image = placeholder
            return
        }
        
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async() { () -> Void in
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
