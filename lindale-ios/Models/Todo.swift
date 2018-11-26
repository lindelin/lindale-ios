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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.myTodos) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let myTodoCollection = try! coder.decode(MyTodoCollection.self, from: data)
                    myTodoCollection.store()
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
    
    static func more(nextUrl url: URL, completion: @escaping (MyTodoCollection?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<LoadMoreService>()
        provider.request(.load(url: url)) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let myTodoCollection = try! coder.decode(MyTodoCollection.self, from: data)
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
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let archiveURL = cachesDirectory.appendingPathComponent("MyTodoCollection").appendingPathExtension("json")
        try! myTodoCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    static func find() -> MyTodoCollection? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("MyTodoCollection").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let myTodoCollection = try coder.decode(MyTodoCollection.self, from: data)
            return myTodoCollection
        } catch {
            return nil
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
    
    func delete(completion: @escaping ([String: String]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.deleteTodo(todo: self)) { result in
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
    
    func changeColor(colorId: Int, completion: @escaping ([String: String]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.changeTodoColor(todo: self, colorId: colorId)) { result in
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
    
    func complete(completion: @escaping ([String: String]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.updateTodoToFinished(todo: self)) { result in
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
    
    struct EditResources: Codable {
        var statuses:[Status]
        
        enum CodingKeys: String, CodingKey {
            case statuses
        }
        
        struct Status: Codable {
            var id: Int
            var name: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
            }
        }
        
        static func load(completion: @escaping (EditResources?) -> Void) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let provider = MoyaProvider<NetworkService>()
            provider.request(.todoEditResource) { result in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let editResources = try! coder.decode(EditResources.self, from: data)
                        completion(editResources)
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

struct TodoRegister {
    var id: Int?
    var content: String?
    var details: String?
    var statusId: Int?
    var colorId: Int?
    var listId: Int?
    var userId: Int?
    
    func update(completion: @escaping ([String: String]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.todoUpdate(todo: self)) { result in
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
