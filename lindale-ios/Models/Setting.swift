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
        
        func update(completion: @escaping ([String: String]?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.profileInfoUpdate(profileInfo: self)) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let status = try! coder.decode([String: String].self, from: data)
                        completion(status)
                    }
                    catch {
                        if response.statusCode == 422 {
                            let data = response.data
                            let coder = JSONDecoder()
                            let errors = try! coder.decode(InputError.self, from: data)
                            var message: String = ""
                            for errors in errors.errors {
                                for error in errors.value {
                                    message += error
                                }
                            }
                            completion(["status": errors.message, "messages": message])
                        } else {
                            print(error)
                            completion(nil)
                        }
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
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
        
        func update(completion: @escaping ([String: String]?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.notificationUpdate(notificationSettings: self)) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let status = try! coder.decode([String: String].self, from: data)
                        completion(status)
                    }
                    catch {
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
        
        static func load(completion: @escaping (Settings.Notification?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.notificationSettings) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let notificationSettings = try! coder.decode(Settings.Notification.self, from: data)
                        completion(notificationSettings)
                    }
                    catch {
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
    struct Password {
        var password: String?
        var newPassword: String?
        var newPasswordConfirmation: String?
        
        func save(completion: @escaping ([String: String]?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.resetPassword(password: self)) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let status = try! coder.decode([String: String].self, from: data)
                        completion(status)
                    }
                    catch {
                        if response.statusCode == 422 {
                            let data = response.data
                            let coder = JSONDecoder()
                            let errors = try! coder.decode(InputError.self, from: data)
                            var message: String = ""
                            for errors in errors.errors {
                                for error in errors.value {
                                    message += error
                                }
                            }
                            completion(["status": errors.message, "messages": message])
                        } else {
                            completion(nil)
                        }
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
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
            let provider = MoyaProvider<NetworkService>()
            provider.request(.localeSettings) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let localeSettings = try! coder.decode(Settings.Locale.self, from: data)
                        completion(localeSettings)
                    }
                    catch {
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
        
        static func update(to language: String, completion: @escaping (String?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.localeUpdate(lang: language)) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let message = try! coder.decode([String: String].self, from: data)
                        completion(message["status"])
                    }
                    catch {
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}
