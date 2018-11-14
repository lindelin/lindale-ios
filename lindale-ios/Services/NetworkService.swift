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
    case completeTask(task: TaskResource)
    case deleteTask(task: TaskResource)
    case storeSubTask(subTask: TaskResource.SubTask)
    case deleteSubTask(subTask: TaskResource.SubTask)
    case storeActivity(activity: TaskActivity)
    case deleteTodo(todo: MyTodoCollection.Todo)
    case changeTodoColor(todo: MyTodoCollection.Todo, colorId: Int)
    case updateTodoToFinished(todo: MyTodoCollection.Todo)
}

extension NetworkService: TargetType {
    
    var baseURL: URL { return URL(string: "\(UserDefaults.dataSuite.string(forOAuthKey: .clientUrl)!)/api")! }
    
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
        case .completeTask(let task):
            return "/tasks/\(task.id)/complete"
        case .deleteTask(let task):
            return "/tasks/\(task.id)"
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
        case .deleteSubTask(let subTask):
            return "/sub-tasks/\(subTask.id)"
        case .storeSubTask(let subTask):
            return "/tasks/\(subTask.taskId)/sub-task"
        case .storeActivity(let activity):
            return "/tasks/\(activity.taskId)/activities"
        case .deleteTodo(let todo):
            return "/todos/\(todo.id)"
        case .changeTodoColor(let todo, _):
            return "/todos/\(todo.id)/change-color"
        case .updateTodoToFinished(let todo):
            return "/todos/\(todo.id)/finished"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .notificationSettings, .favoriteProjects:
            return .get
        case .localeUpdate, .resetPassword, .notificationUpdate, .profileInfoUpdate, .updateSubTask, .completeTask, .changeTodoColor, .updateTodoToFinished:
            return .put
        case .deleteTask, .deleteSubTask, .deleteTodo:
            return .delete
        case .storeSubTask, .storeActivity:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .notificationSettings, .favoriteProjects, .deleteTask, .deleteSubTask, .deleteTodo, .updateTodoToFinished:
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
        case let .storeSubTask(subTask):
            return .requestParameters(parameters: [
                "contents": [subTask.content],
                ], encoding: JSONEncoding.default)
        case let .profileInfoUpdate(profileInfo):
            return .requestParameters(parameters: [
                "name": profileInfo.name,
                "content": profileInfo.content,
                "company": profileInfo.company
                ], encoding: JSONEncoding.default)
        case let .completeTask(task):
            return .requestParameters(parameters: [
                "is_finish": task.isFinish,
                ], encoding: JSONEncoding.default)
        case let .storeActivity(activity):
            return .requestParameters(parameters: [
                "content": activity.content,
                ], encoding: JSONEncoding.default)
        case let .changeTodoColor(_ , colorId):
            return .requestParameters(parameters: [
                "color_id": colorId,
                ], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
            case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .localeUpdate, .resetPassword, .notificationSettings, .notificationUpdate, .profileInfoUpdate, .updateSubTask, .favoriteProjects, .completeTask, .deleteTask, .storeSubTask, .deleteSubTask, .storeActivity, .deleteTodo, .changeTodoColor, .updateTodoToFinished:
                return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": OAuth.get()!.token()]
    }
}

enum LoadMoreService {
    case load(url: String)
}

extension LoadMoreService: TargetType {
    var baseURL: URL {
        switch self {
        case .load(let url):
            return URL(string: url)!
        }
    }
    var path: String { return "" }
    var method: Moya.Method { return .get }
    var sampleData: Data { return "Half measures are as bad as nothing at all.".utf8Encoded }
    var task: Task { return .requestPlain }
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": OAuth.get()!.token()]
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
