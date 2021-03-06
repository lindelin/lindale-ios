//
//  Profile.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/10/09.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Moya

struct Profile: Codable {
    var id: Int
    var name: String
    var email: String
    var photo: String?
    var content: String?
    var company: String?
    var location: String?
    var created: String
    var updated: String
    var status: Status
    var progress: Progress
    
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
        case status
        case progress
    }
    
    struct Status: Codable {
        var projectCount: Int
        var unfinishedTaskCount: Int
        var unfinishedTodoCount: Int
        
        enum CodingKeys: String, CodingKey {
            case projectCount = "project_count"
            case unfinishedTaskCount = "unfinished_task_count"
            case unfinishedTodoCount = "unfinished_todo_count"
        }
    }
    
    struct Progress: Codable {
        var total: Int
        var task: Int
        var todo: Int
        
        enum CodingKeys: String, CodingKey {
            case total
            case task
            case todo
        }
    }
    
    static func resources(completion: @escaping (Profile?) -> Void) {
        let provider = MoyaProvider<NetworkService>()
        provider.request(.profile) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let profile = try! coder.decode(Profile.self, from: data)
                    profile.store()
                    completion(profile)
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
        let profile = try! coder.encode(self)
        let cachesDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaults.AppGroup)!
        let archiveURL = cachesDirectory.appendingPathComponent("Profile").appendingPathExtension("json")
        try! profile.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    static func find() -> Profile? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaults.AppGroup)!
            let archiveURL = cachesDirectory.appendingPathComponent("Profile").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let profile = try coder.decode(Profile.self, from: data)
            return profile
        } catch {
            return nil
        }
    }
}

