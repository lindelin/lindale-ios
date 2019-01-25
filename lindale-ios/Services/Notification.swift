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
    static let taskHasUpdated = Notification.Name("taskHasUpdated")
    static let taskHasCreated = Notification.Name("taskHasCreated")
    static let taskHasDeleted = Notification.Name("taskHasDeleted")
    static let localeSettingsHasUpdated = Notification.Name("localeSettingsHasUpdated")
    static let profileInfoHasUpdated = Notification.Name("profileInfoHasUpdated")
    static let taskActivityHasUpdated = Notification.Name("taskActivityHasUpdated")
    static let todoHasUpdated = Notification.Name("todoHasUpdated")
    static let wikiHasUpdated = Notification.Name("wikiHasUpdated")
    static let wikiTypeHasUpdated = Notification.Name("wikiTypeHasUpdated")
    static let taskGroupHasUpdated = Notification.Name("taskGroupHasUpdated")
}
