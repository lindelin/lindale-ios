//
//  Todo.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/16.
//  Copyright © 2018年 lindelin. All rights reserved.
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
    
    static func resources(completion: @escaping (MyTodoCollection?) -> Void) {
        NetworkProvider.main.data(request: .myTodos) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let myTodoCollection = try! JSONDecoder.main.decode(MyTodoCollection.self, from: data)
            myTodoCollection.store()
            completion(myTodoCollection)
        }
    }
    
    static func more(nextUrl url: URL, completion: @escaping (MyTodoCollection?) -> Void) {
        NetworkProvider.main.moreData(request: .load(url: url)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let myTodoCollection = try! JSONDecoder.main.decode(MyTodoCollection.self, from: data)
            completion(myTodoCollection)
        }
    }
    
    func store() {
        let coder = JSONEncoder()
        let myTodoCollection = try! coder.encode(self)
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let archiveURL = cachesDirectory.appendingPathComponent("MyTodoCollection-\(UserDefaults.standard.string(forOAuthKey: .userName) ?? "")").appendingPathExtension("json")
        try! myTodoCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    static func find() -> MyTodoCollection? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("MyTodoCollection-\(UserDefaults.standard.string(forOAuthKey: .userName) ?? "")").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let myTodoCollection = try coder.decode(MyTodoCollection.self, from: data)
            return myTodoCollection
        } catch {
            return nil
        }
    }
}

struct TodoCollection: Codable {
    var todos: [Todo]
    var links: Links
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case todos = "data"
        case links
        case meta
    }
    
    static func resources(project: ProjectCollection.Project, completion: @escaping (TodoCollection?) -> Void) {
        NetworkProvider.main.data(request: .projectTodos(project: project)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let todoCollection = try! JSONDecoder.main.decode(TodoCollection.self, from: data)
            completion(todoCollection)
        }
    }
    
    static func more(nextUrl url: URL, completion: @escaping (TodoCollection?) -> Void) {
        NetworkProvider.main.moreData(request: .load(url: url)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let todoCollection = try! JSONDecoder.main.decode(TodoCollection.self, from: data)
            completion(todoCollection)
        }
    }
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
    
    func delete(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .deleteTodo(todo: self)) { (status) in
            completion(status)
        }
    }
    
    func changeColor(colorId: Int, completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .changeTodoColor(todo: self, colorId: colorId)) { (status) in
            completion(status)
        }
    }
    
    func complete(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .updateTodoToFinished(todo: self)) { (status) in
            completion(status)
        }
    }
    
    struct EditResources: Codable {
        var statuses: [Status]
        var users: [User]
        
        enum CodingKeys: String, CodingKey {
            case statuses
            case users
        }
        
        struct Status: Codable {
            var id: Int
            var name: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
            }
        }
        
        static func load(todo: Todo, completion: @escaping (EditResources?) -> Void) {
            NetworkProvider.main.data(request: .todoEditResource(todo: todo)) { (data) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let editResources = try! JSONDecoder.main.decode(EditResources.self, from: data)
                completion(editResources)
            }
        }
    }
}

struct TodoRegister {
    var id: Int?
    var content: String?
    var details: String?
    var statusId: Int?
    var colorId: Int?
    var listId: Int?
    var userId: Int?
    
    func update(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .todoUpdate(todo: self)) { (status) in
            completion(status)
        }
    }
}
