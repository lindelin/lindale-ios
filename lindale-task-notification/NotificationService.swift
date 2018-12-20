//
//  NotificationService.swift
//  lindale-task-notification
//
//  Created by Jie Wu on 2018/12/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            //bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            let imageKey = AnyHashable("gcm.notification.image")
            
            if let imageUrl = request.content.userInfo[imageKey] as? String {
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let task = session.dataTask(with: URL(string: imageUrl)!, completionHandler: { (data, response, error) in
                    if let data = data {
                        do {
                            let writePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("push.png")
                            try data.write(to: writePath)
                            let attachment = try UNNotificationAttachment(identifier: "nnsnodnb_demo", url: writePath, options: nil)
                            bestAttemptContent.attachments = [attachment]
                            contentHandler(bestAttemptContent)
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            contentHandler(bestAttemptContent)
                        }
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            } else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
