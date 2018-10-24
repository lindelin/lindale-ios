//
//  Notification.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/13.
//  Copyright © 2018 lindelin. All rights reserved.
//
import Foundation

struct LocalNotificationService {
    static let subTaskHasUpdated = Notification.Name("subTaskHasUpdated")
    static let localeSettingsHasUpdated = Notification.Name("localeSettingsHasUpdated")
    static let profileInfoHasUpdated = Notification.Name("profileInfoHasUpdated")
}
