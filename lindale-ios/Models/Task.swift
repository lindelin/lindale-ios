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
