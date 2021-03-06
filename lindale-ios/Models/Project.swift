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
        var image: URL
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
    }
    
    static func resources(completion: @escaping (ProjectCollection?) -> Void) {
        NetworkProvider.main.data(request: .projects) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
        
            let projectCollection = try! JSONDecoder.main.decode(ProjectCollection.self, from: data)
            projectCollection.store()
            completion(projectCollection)
        }
    }
    
    static func more(nextUrl url: URL, completion: @escaping (ProjectCollection?) -> Void) {
        NetworkProvider.main.moreData(request: .load(url: url)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let projectCollection = try! JSONDecoder.main.decode(ProjectCollection.self, from: data)
            completion(projectCollection)
        }
    }
    
    static func favorites(completion: @escaping ([ProjectCollection.Project]?) -> Void) {
        NetworkProvider.main.data(request: .favoriteProjects) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let favorites = try! JSONDecoder.main.decode([ProjectCollection.Project].self, from: data)
            completion(favorites)
        }
    }
    
    func store() {
        let coder = JSONEncoder()
        let projectCollection = try! coder.encode(self)
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let archiveURL = cachesDirectory.appendingPathComponent("ProjectCollection-\(UserDefaults.standard.string(forOAuthKey: .userName) ?? "")").appendingPathExtension("json")
        try! projectCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
    }
    
    static func find() -> ProjectCollection? {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("ProjectCollection-\(UserDefaults.standard.string(forOAuthKey: .userName) ?? "")").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let projectCollection = try coder.decode(ProjectCollection.self, from: data)
            return projectCollection
        } catch {
            return nil
        }
    }
}

struct ProjectTopResource: Codable {
    var status: Status
    var progress: Progress
    var milestones: [Milestone]
    var activity: String
    
    static func load(project: ProjectCollection.Project, completion: @escaping (ProjectTopResource?) -> Void) {
        NetworkProvider.main.data(request: .projectTopResources(project: project)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let projectTopResource = try! JSONDecoder.main.decode(ProjectTopResource.self, from: data)
            completion(projectTopResource)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case progress
        case milestones
        case activity
    }
    
    struct Status: Codable {
        var task: String
        var todo: String
        var event: String
        
        enum CodingKeys: String, CodingKey {
            case task
            case todo
            case event
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
    
    struct Milestone: Codable {
        var title: String
        var color: Int
        var type: String
        var typeColor: Int
        var progress: Int
        
        enum CodingKeys: String, CodingKey {
            case title
            case color
            case type
            case typeColor = "type_color"
            case progress
        }
    }
}

struct ProjectRegister {
    var id: Int?
    var title: String?
    var content: String?
    var startAt: String?
    var endAt: String?
    var type: String?
    var SlId: Int?
    var status: String?
    var password: String?
    var passwordConfirmation: String?
    var image: UIImage?
    
    func store(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .storeProject(project: self)) { (status) in
            completion(status)
        }
    }
}

