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
    case groupTasks(group: TaskGroup)
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
    case storeSubTask(subTask: SubTaskRegister)
    case deleteSubTask(subTask: TaskResource.SubTask)
    case storeActivity(activity: TaskActivityRegister)
    case deleteTodo(todo: Todo)
    case changeTodoColor(todo: Todo, colorId: Int)
    case updateTodoToFinished(todo: Todo)
    case todoEditResource(todo: Todo)
    case taskEditResource(task: TaskResource)
    case todoUpdate(todo: TodoRegister)
    case taskUpdate(task: TaskRegister)
    case projectTopResources(project: ProjectCollection.Project)
    case projectTaskGroups(project: ProjectCollection.Project)
    case projectWikiTypes(project: ProjectCollection.Project)
    case projectMembers(project: ProjectCollection.Project)
    case projectTodos(project: ProjectCollection.Project)
    case storeDeviceToken(device: Device)
    case projectWikis(project: ProjectCollection.Project, type: WikiType)
    case updateWiki(wiki: WikiRegister)
    case wikiDetail(id: Int)
    case storeTodoList(todoList: TodoListRegister)
    case storeTodo(todo: TodoRegister)
    case uploadProfilePhoto(image: UIImage)
    case taskGroupEditResource(project: ProjectCollection.Project)
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
        case .groupTasks(let group):
            return "/tasks/group/\(group.id)"
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
        case .uploadProfilePhoto:
            return "/settings/profile/upload"
        case .updateSubTask(let subTask):
            return "/sub-tasks/\(subTask.id)"
        case .deleteSubTask(let subTask):
            return "/sub-tasks/\(subTask.id)"
        case .storeSubTask(let subTask):
            return "/tasks/\(subTask.taskId!)/sub-task"
        case .storeActivity(let activity):
            return "/tasks/\(activity.taskId)/activities"
        case .deleteTodo(let todo):
            return "/todos/\(todo.id)"
        case .changeTodoColor(let todo, _):
            return "/todos/\(todo.id)/change-color"
        case .updateTodoToFinished(let todo):
            return "/todos/\(todo.id)/finished"
        case .todoUpdate(let todo):
            return "/todos/\(todo.id!)"
        case .todoEditResource(let todo):
            return "/todos/\(todo.id)/edit-resource"
        case .taskEditResource(let task):
            return "/tasks/\(task.id)/edit-resource"
        case .taskUpdate(let task):
            return "/tasks/\(task.id!)"
        case .projectTopResources(let project):
            return "/projects/\(project.id)/top"
        case .projectTaskGroups(let project):
            return "/projects/\(project.id)/tasks/groups"
        case .projectWikiTypes(let project):
            return "/projects/\(project.id)/wikis/types"
        case .projectMembers(let project):
            return "/projects/\(project.id)/members"
        case .projectTodos(let project):
            return "/projects/\(project.id)/todos"
        case .storeDeviceToken:
            return "/device-token"
        case .projectWikis(let project, let type):
            return "/projects/\(project.id)/wikis/types/\(type.id)"
        case .updateWiki(let wiki):
            return "wikis/\(wiki.id!)"
        case .wikiDetail(let id):
            return "wikis/\(id)"
        case .storeTodoList(let todoList):
            return "/projects/\(todoList.projectId!)/todo-list"
        case .storeTodo(let todo):
            return "/projects/\(todo.projectId!)/todos"
        case .taskGroupEditResource(let project):
            return "/projects/\(project.id)/tasks/groups/edit-resource"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .groupTasks, .myTaskDetail, .localeSettings, .notificationSettings, .favoriteProjects, .todoEditResource, .taskEditResource, .projectTopResources, .projectTaskGroups, .projectWikiTypes, .projectMembers, .projectTodos, .projectWikis, .wikiDetail, .taskGroupEditResource:
            return .get
        case .localeUpdate, .resetPassword, .notificationUpdate, .profileInfoUpdate, .updateSubTask, .completeTask, .changeTodoColor, .updateTodoToFinished, .todoUpdate, .taskUpdate:
            return .put
        case .deleteTask, .deleteSubTask, .deleteTodo:
            return .delete
        case .storeSubTask, .storeActivity, .storeDeviceToken, .storeTodoList, .storeTodo, .uploadProfilePhoto, .updateWiki:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .groupTasks, .localeSettings, .notificationSettings, .favoriteProjects, .deleteTask, .deleteSubTask, .deleteTodo, .updateTodoToFinished, .todoEditResource, .taskEditResource, .projectTopResources, .projectTaskGroups, .projectWikiTypes, .projectMembers, .projectTodos, .projectWikis, .wikiDetail, .taskGroupEditResource:
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
        case let .uploadProfilePhoto(image):
            let imageData = image.jpegData(compressionQuality: 1.0)!
            return .uploadMultipart([MultipartFormData(provider: .data(imageData),
                                                       name: "photo",
                                                       fileName: "photo.jpg",
                                                       mimeType: "image/jpg")])
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
        case let .todoUpdate(todo):
            return .requestParameters(parameters: [
                "content": todo.content as Any,
                "details": todo.details as Any,
                "status_id": todo.statusId as Any,
                "user_id": todo.userId as Any,
                "color_id": todo.colorId as Any,
                "list_id": todo.listId as Any
                ], encoding: JSONEncoding.default)
        case let .taskUpdate(task):
            return .requestParameters(parameters: [
                "group_id": task.groupId as Any,
                "title": task.title as Any,
                "content": task.content as Any,
                "start_at": task.startAt as Any,
                "end_at": task.endAt as Any,
                "cost": task.cost as Any,
                "type_id": task.typeId as Any,
                "user_id": task.userId as Any,
                "status_id": task.statusId as Any,
                "priority_id": task.priorityId as Any,
                "color_id": task.colorId as Any
                ], encoding: JSONEncoding.default)
        case let .storeDeviceToken(device):
            return .requestParameters(parameters: [
                "token": device.token,
                "name": device.name,
                "type": device.type,
                "revoked": false
                ], encoding: JSONEncoding.default)
        case let .updateWiki(wiki):
            let imageData = wiki.image?.jpegData(compressionQuality: 1.0)!
            if let imageData = imageData {
                return .uploadMultipart([
                    MultipartFormData(provider: .data("PUT".data(using: .utf8)!), name: "_method"),
                    MultipartFormData(provider: .data(imageData),
                                      name: "image",
                                      fileName: "image.jpg",
                                      mimeType: "image/jpg"),
                    MultipartFormData(provider: .data((wiki.title ?? "").data(using: .utf8)!), name: "title"),
                    MultipartFormData(provider: .data((wiki.content ?? "").data(using: .utf8)!), name: "content")
                    ])
            } else {
                return .requestParameters(parameters: [
                    "title": wiki.title as Any,
                    "content": wiki.content as Any,
                    "_method": "PUT"
                    ], encoding: JSONEncoding.default)
            }
        case let .storeTodoList(todoList):
            return .requestParameters(parameters: [
                "type_name": todoList.title as Any
                ], encoding: JSONEncoding.default)
        case let .storeTodo(todo):
            return .requestParameters(parameters: [
                "content": todo.content as Any,
                ], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": OAuth.get()!.token()]
    }
}

enum LoadMoreService {
    case load(url: URL)
}

extension LoadMoreService: TargetType {
    var baseURL: URL {
        switch self {
        case .load(let url):
            return url
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

class NetworkProvider {
    
    static let main = NetworkProvider()
    
    let provider = MoyaProvider<NetworkService>()
    let loadMoreProvider = MoyaProvider<LoadMoreService>()
    
    func data(request: NetworkService, completion: @escaping (Data?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        provider.request(request) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    completion(data)
                }
                catch {
                    if response.statusCode == 401 {
                        UserDefaults.dataSuite.set(true, forOAuthKey: .hasAuthError)
                    }
                    if response.statusCode == 403 {
                        UserDefaults.dataSuite.set(true, forOAuthKey: .hasAuthorizationError)
                    }
                    completion(nil)
                    print(error)
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func moreData(request: LoadMoreService, completion: @escaping (Data?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadMoreProvider.request(request) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    completion(data)
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
    
    func message(request: NetworkService, completion: @escaping ([String: String]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        provider.request(request) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
                        completion(["status": "NG", "messages": "Network Error!"])
                    }
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                completion(["status": "NG", "messages": "Network Error!"])
            }
        }
    }
}
