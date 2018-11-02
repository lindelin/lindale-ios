//
//  Task.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/14.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Moya

struct MyTaskCollection: Codable {
    var tasks: [Task]
    var links: Links
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case tasks = "data"
        case links
        case meta
    }
    
    struct Task: Codable {
        var projectName: String
        var id: Int
        var initiatorName: String
        var title: String
        var content: String?
        var startAt: String?
        var endAt: String?
        var cost: Int
        var progress: Int
        var userName: String
        var color: Int
        var type: String
        var status: String
        var subTaskStatus: String
        var group: String?
        var priority: String
        var isFinish: Int
        var updatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case projectName = "project_name"
            case id
            case initiatorName = "initiator_name"
            case title
            case content
            case startAt = "start_at"
            case endAt = "end_at"
            case cost
            case progress
            case userName = "user_name"
            case color
            case type
            case status
            case subTaskStatus = "sub_task_status"
            case group
            case priority
            case isFinish = "is_finish"
            case updatedAt = "updated_at"
        }
    }
    
    struct Links: Codable {
        var first: String?
        var last: String?
        var prev: String?
        var next: String?
        
        enum CodingKeys: String, CodingKey {
            case first
            case last
            case prev
            case next
        }
    }
    
    struct Meta: Codable {
        var currentPage: Int?
        var from: Int?
        var lastPage: Int?
        var path: String?
        var perPage: Int?
        var to: Int?
        var total: Int?
        
        enum CodingKeys: String, CodingKey {
            case currentPage = "current_page"
            case from
            case lastPage = "last_page"
            case path
            case perPage = "per_page"
            case to
            case total
        }
    }
    
    static func resources(completion: @escaping (MyTaskCollection?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.myTasks) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let myTaskCollection = try! coder.decode(MyTaskCollection.self, from: data)
                    myTaskCollection.store()
                    completion(myTaskCollection)
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
    
    func store() {
        let coder = JSONEncoder()
        let myTaskCollection = try! coder.encode(self)
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let archiveURL = cachesDirectory.appendingPathComponent("MyTaskCollection").appendingPathExtension("json")
        try! myTaskCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    func shortcut() -> TaskShortcut {
        let title = "\(self.tasks[0].type): \(self.tasks[0].title)"
        return TaskShortcut(id: self.tasks[0].id,
                            title: title,
                            status: self.tasks[0].status,
                            startAt: self.tasks[0].startAt,
                            endAt: self.tasks[0].endAt)
    }
    
    static func find() -> MyTaskCollection? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("MyTaskCollection").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let myTaskCollection = try coder.decode(MyTaskCollection.self, from: data)
            return myTaskCollection
        } catch {
            return nil
        }
    }
}

struct TaskResource: Codable {
    var project: String
    var id: Int
    var initiator: User?
    var title: String
    var content: String?
    var startAt: String?
    var endAt: String?
    var cost: Int
    var progress: Int
    var user: User
    var color: Int
    var type: String
    var status: String
    var subTaskStatus: String
    var group: String?
    var priority: String
    var isFinish: Int
    var updatedAt: String
    var subTasks: [SubTask]
    var taskActivities: [TaskActivity]
    
    enum CodingKeys: String, CodingKey {
        case project
        case id
        case initiator
        case title
        case content
        case startAt = "start_at"
        case endAt = "end_at"
        case cost
        case progress
        case user
        case color
        case type
        case status
        case subTaskStatus = "sub_task_status"
        case group
        case priority
        case isFinish = "is_finish"
        case updatedAt = "updated_at"
        case subTasks = "sub_tasks"
        case taskActivities = "task_activities"
    }
    
    struct User: Codable {
        var id: Int
        var name: String
        var email: String
        var photo: String?
        var content: String?
        var company: String?
        var location: String?
        var created: String
        var updated: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case email
            case photo
            case content
            case company
            case location
            case created = "created_at"
            case updated = "updated_at"
        }
    }
    
    struct SubTask: Codable {
        
        static let on = 1
        static let off = 0
        
        var taskId: Int
        var id: Int
        var content: String
        var isFinish: Int
        
        init(taskId: Int, content: String?) {
            self.taskId = taskId
            self.content = content ?? ""
            self.id = 0
            self.isFinish = 0
        }
        
        enum CodingKeys: String, CodingKey {
            case taskId = "task_id"
            case id
            case content
            case isFinish = "is_finish"
        }
        
        func isCompleted() -> Bool {
            return self.isFinish == 1 ? true : false
        }
        
        func store(completion: @escaping ([String: String]?) -> Void) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let provider = MoyaProvider<NetworkService>()
            provider.request(.storeSubTask(subTask: self)) { result in
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
                        print(error)
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
        
        func update(completion: @escaping ([String: String]?) -> Void) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let provider = MoyaProvider<NetworkService>()
            provider.request(.updateSubTask(subTask: self)) { result in
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
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
        
        func delete(completion: @escaping ([String: String]?) -> Void) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let provider = MoyaProvider<NetworkService>()
            provider.request(.deleteSubTask(subTask: self)) { result in
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
    
    struct TaskActivity: Codable {
        var taskId: Int
        var id: Int
        var content: String
        var user: User
        var updateAt: String
        
        enum CodingKeys: String, CodingKey {
            case taskId = "task_id"
            case id
            case content
            case user
            case updateAt = "update_at"
        }
    }
    
    static func load(id: Int, completion: @escaping (TaskResource?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.myTaskDetail(id: id)) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let taskResource = try! coder.decode(TaskResource.self, from: data)
                    completion(taskResource)
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
    
    enum CompleteStatus: Int {
        case completed = 1
        case incomplete = 0
    }
    
    mutating func changeCompleteStatus(to: CompleteStatus, completion: @escaping ([String: String]?) -> Void) {
        
        self.isFinish = to.rawValue
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.completeTask(task: self)) { result in
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
                    completion(nil)
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func delete(completion: @escaping ([String: String]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.deleteTask(task: self)) { result in
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

struct TaskActivity {
    var taskId: Int
    var content: String
    
    init(taskId: Int, content: String?) {
        self.taskId = taskId
        self.content = content ?? ""
    }
    
    func store(completion: @escaping ([String: String]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.storeActivity(activity: self)) { result in
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
                    print(error)
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
