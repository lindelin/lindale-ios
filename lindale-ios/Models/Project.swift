//
//  Projects.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Moya

struct ProjectCollection: Codable {
    var projects: [Project]
    var links: Links
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case projects = "data"
        case links
        case meta
    }
    
    struct Project: Codable {
        var id: Int
        var title: String
        var content: String?
        var start: String?
        var end: String?
        var image: String?
        var pl: User
        var sl: User?
        var type: String?
        var status: String?
        var taskStatus: String?
        var todoStatus: String?
        var progress: Int?
        var created: String?
        var updated: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case content
            case start = "start_at"
            case end = "end_at"
            case image
            case pl
            case sl
            case type
            case status
            case taskStatus = "task_status"
            case todoStatus = "todo_status"
            case progress
            case created = "created_at"
            case updated = "updated_at"
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
    
    static func resources(completion: @escaping (ProjectCollection?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.projects) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let projectCollection = try! coder.decode(ProjectCollection.self, from: data)
                    projectCollection.store()
                    completion(projectCollection)
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
    
    static func more(nextUrl url: String, completion: @escaping (ProjectCollection?) -> Void) {
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
                    let projectCollection = try! coder.decode(ProjectCollection.self, from: data)
                    projectCollection.store()
                    completion(projectCollection)
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
    
    static func favorites(completion: @escaping ([ProjectCollection.Project]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<NetworkService>()
        provider.request(.favoriteProjects) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let favorites = try! coder.decode([ProjectCollection.Project].self, from: data)
                    completion(favorites)
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
        let projectCollection = try! coder.encode(self)
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let archiveURL = cachesDirectory.appendingPathComponent("ProjectCollection").appendingPathExtension("json")
        try! projectCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    static func find() -> ProjectCollection? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("ProjectCollection").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let projectCollection = try coder.decode(ProjectCollection.self, from: data)
            return projectCollection
        } catch {
            return nil
        }
    }
}
