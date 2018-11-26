//
//  Todo.swift
//  lindale-watch Extension
//
//  Created by LINDALE on 2018/10/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Moya

struct MyTodoCollection: Codable {
    var todos: [Todo]
    var links: Links
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case todos = "data"
        case links
        case meta
    }
    
    struct Todo: Codable {
        var id: Int
        var initiator: User?
        var content: String
        var details: String?
        var type: String
        var status: String
        var action: Int
        var color: Int
        var listName: String?
        var user: User?
        var projectName: String
        var updatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case initiator
            case content
            case details
            case type
            case status
            case action
            case color
            case listName = "list_name"
            case user
            case projectName = "project_name"
            case updatedAt = "updated_at"
        }
    }
    
    static func resources(completion: @escaping (MyTodoCollection?) -> Void) {
        let provider = MoyaProvider<NetworkService>()
        provider.request(.myTodos) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let myTodoCollection = try! coder.decode(MyTodoCollection.self, from: data)
                    myTodoCollection.store()
                    ShortcutManager.main.updateTodoShortcut(shortcut: myTodoCollection.shortcut())
                    completion(myTodoCollection)
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
        let myTodoCollection = try! coder.encode(self)
        let cachesDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaults.AppGroup)!
        let archiveURL = cachesDirectory.appendingPathComponent("MyTodoCollection").appendingPathExtension("json")
        try! myTodoCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    func shortcut() -> TodoShortcut {
        let content = "TODO: \(self.todos[0].content)"
        return TodoShortcut(id: self.todos[0].id, content: content, status: self.todos[0].status)
    }
    
    static func find() -> MyTodoCollection? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaults.AppGroup)!
            let archiveURL = cachesDirectory.appendingPathComponent("MyTodoCollection").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let myTodoCollection = try coder.decode(MyTodoCollection.self, from: data)
            return myTodoCollection
        } catch {
            return nil
        }
    }
}
