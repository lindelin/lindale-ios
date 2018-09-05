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
        let provider = MoyaProvider<NetworkService>()
        provider.request(.projects) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let projectCollection = try! coder.decode(ProjectCollection.self, from: data)
                    completion(projectCollection)
                }
                catch {
                    completion(nil)
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("エラー", error)
            }
        }
    }
}
