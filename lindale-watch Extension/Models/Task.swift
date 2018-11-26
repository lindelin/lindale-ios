//
//  Task.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/09/21.
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
        var initiator: User?
        var title: String
        var content: String?
        var startAt: String?
        var endAt: String?
        var cost: Int
        var progress: Int
        var user: User?
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
        }
    }
    
    static func resources(completion: @escaping (MyTaskCollection?) -> Void) {
        let provider = MoyaProvider<NetworkService>()
        provider.request(.myTasks) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let myTaskCollection = try! coder.decode(MyTaskCollection.self, from: data)
                    myTaskCollection.store()
                    ShortcutManager.main.updateTaskShortcut(shortcut: myTaskCollection.shortcut())
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
        let cachesDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaults.AppGroup)!
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
            let cachesDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaults.AppGroup)!
            let archiveURL = cachesDirectory.appendingPathComponent("MyTaskCollection").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let myTaskCollection = try coder.decode(MyTaskCollection.self, from: data)
            return myTaskCollection
        } catch {
            return nil
        }
    }
}

