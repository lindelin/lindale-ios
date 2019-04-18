//
//  PushNotificationService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/19.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let badgeCount = notification.request.content.badge?.intValue
        var badges = UIApplication.shared.applicationIconBadgeNumber
        if let count = badgeCount {
            badges += count
        }
        UIApplication.shared.applicationIconBadgeNumber = badges
        
        switch notification.request.content.categoryIdentifier {
        case "TODO_EVENT":
            NotificationCenter.default.post(name: LocalNotificationService.todoHasUpdated, object: nil)
            break
        case "TASK_EVENT":
            NotificationCenter.default.post(name: LocalNotificationService.taskHasUpdated, object: nil)
            break
        default:
            break
        }
        
        // アプリ起動中でも通知をアラート表示する
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 通知が開封された時（通知が開封されたことを真偽値で判断して表示する下タブを分岐する）
        switch response.notification.request.content.categoryIdentifier {
        case "TODO_EVENT":
            break
        case "TASK_EVENT":
            break
        default:
            break
        }
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        if UserDefaults.standard.string(forOAuthKey: .fcmToken) != fcmToken {
            UserDefaults.standard.set(fcmToken, forOAuthKey: .fcmToken)
            UserDefaults.standard.synchronize()
        }
        
        if OAuth.get() != nil {
            DispatchQueue.main.async {
                Device(token: fcmToken).store(completion: { (response) in
                    guard response["status"] == "OK" else {
                        print("Store Firebase token Error: \(String(describing: response["messages"]))")
                        return
                    }
                    print("Store Firebase token OK: \(String(describing: response["messages"]))")
                })
            }
        }
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
