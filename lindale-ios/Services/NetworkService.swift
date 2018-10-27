//
//  NetworkService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Moya

enum NetworkService {
    case projects
    case favoriteProjects
    case profile
    case myTasks
    case myTodos
    case myTaskDetail(id: Int)
    case localeSettings
    case localeUpdate(lang: String)
    case resetPassword(password: Settings.Password)
    case notificationSettings
    case notificationUpdate(notificationSettings: Settings.Notification)
    case profileInfoUpdate(profileInfo: Settings.ProfileInfo)
    case updateSubTask(subTask: TaskResource.SubTask)
}

extension NetworkService: TargetType {
    
    var baseURL: URL { return URL(string: "\(UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.clientUrl.rawValue)!)/api")! }
    
    var path: String {
        switch self {
        case .projects:
            return "/projects"
        case .favoriteProjects:
            return "/projects/favorites"
        case .profile:
            return "/profile"
        case .myTasks:
            return "/tasks"
        case .myTaskDetail(let id):
            return "/tasks/\(id)"
        case .myTodos:
            return "/todos"
        case .localeSettings, .localeUpdate:
            return "/settings/locale"
        case .resetPassword:
            return "/settings/password"
        case .notificationSettings, .notificationUpdate:
            return "/settings/notification"
        case .profileInfoUpdate:
            return "/settings/profile"
        case .updateSubTask(let subTask):
            return "/sub-tasks/\(subTask.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .notificationSettings, .favoriteProjects:
            return .get
        case .localeUpdate, .resetPassword, .notificationUpdate, .profileInfoUpdate, .updateSubTask:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .notificationSettings, .favoriteProjects:
            return .requestPlain
        case let .localeUpdate(lang):
            return .requestParameters(parameters: ["language": lang], encoding: JSONEncoding.default)
        case let .resetPassword(password):
            return .requestParameters(parameters: [
                    "password": password.password ?? "",
                    "new_password": password.newPassword ?? "",
                    "new_password_confirmation": password.newPasswordConfirmation ?? ""
                ], encoding: JSONEncoding.default)
        case let .notificationUpdate(notificationSettings):
            return .requestParameters(parameters: [
                "slack": notificationSettings.slack,
                ], encoding: JSONEncoding.default)
        case let .updateSubTask(subTask):
            return .requestParameters(parameters: [
                "is_finish": subTask.isFinish,
                ], encoding: JSONEncoding.default)
        case let .profileInfoUpdate(profileInfo):
            return .requestParameters(parameters: [
                "name": profileInfo.name,
                "content": profileInfo.content,
                "company": profileInfo.company
                ], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
            case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .localeUpdate, .resetPassword, .notificationSettings, .notificationUpdate, .profileInfoUpdate, .updateSubTask, .favoriteProjects:
                return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": (OAuth.get()?.token())!]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
