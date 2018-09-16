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
    
    struct Todo: Codable {
        var id: Int
        var initiatorName: String?
        var content: String?
        var details: String?
        var type: String
        var status: String
        var color: Int
        var listName: String?
        var userName: String
        var projectName: String
        var updatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case initiatorName = "initiator_name"
            case content
            case details
            case type
            case status
            case color
            case listName = "list_name"
            case userName = "user_name"
            case projectName = "project_name"
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
