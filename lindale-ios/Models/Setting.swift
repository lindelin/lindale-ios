//
//  Setting.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation
import Moya
import UIKit

struct Settings {
    
    struct ProfileInfo {
        var name: String
        var content: String
        var company: String
        
        func update(completion: @escaping ([String: String]) -> Void) {
            NetworkProvider.main.message(request: .profileInfoUpdate(profileInfo: self)) { (status) in
                completion(status)
            }
        }
        
        static func upload(photo: UIImage, completion: @escaping ([String: String]) -> Void) {
            NetworkProvider.main.message(request: .uploadProfilePhoto(image: photo)) { (status) in
                completion(status)
            }
        }
    }
    
    struct Notification: Codable {
        static let on = "on"
        static let off = "off"
        
        var slack: String
        
        enum CodingKeys: String, CodingKey {
            case slack
        }
        
        func slackIsOn() -> Bool {
            if self.slack == Notification.on {
                return true
            } else if self.slack == Notification.off {
                return false
            } else {
                return false
            }
        }
        
        func update(completion: @escaping ([String: String]) -> Void) {
            NetworkProvider.main.message(request: .notificationUpdate(notificationSettings: self)) { (status) in
                completion(status)
            }
        }
        
        static func load(completion: @escaping (Settings.Notification?) -> Void) {
            NetworkProvider.main.data(request: .notificationSettings) { (data) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let notificationSettings = try! JSONDecoder.main.decode(Settings.Notification.self, from: data)
                completion(notificationSettings)
            }
        }
    }
    
    struct Password {
        var password: String?
        var newPassword: String?
        var newPasswordConfirmation: String?
        
        func save(completion: @escaping ([String: String]) -> Void) {
            NetworkProvider.main.message(request: .resetPassword(password: self)) { (status) in
                completion(status)
            }
        }
    }
    
    struct Locale: Codable {
        var currentLanguage: String
        var currentLanguageName: String
        var options: [String: String]
        
        enum CodingKeys: String, CodingKey {
            case currentLanguage = "current_language"
            case currentLanguageName = "current_language_name"
            case options = "options"
        }
        
        struct Option {
            var key: String
            var value: String
        }
        
        func optionObjs() -> [Option] {
            var tmp: [Option] = []
            for option in self.options {
                tmp.append(Option(key: option.key, value: option.value))
            }
            
            return tmp
        }
        
        static func load(completion: @escaping (Settings.Locale?) -> Void) {
            NetworkProvider.main.data(request: .localeSettings) { (data) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let localeSettings = try! JSONDecoder.main.decode(Settings.Locale.self, from: data)
                completion(localeSettings)
            }
        }
        
        static func update(to language: String, completion: @escaping ([String: String]) -> Void) {
            NetworkProvider.main.message(request: .localeUpdate(lang: language)) { (status) in
                completion(status)
            }
        }
    }
}
