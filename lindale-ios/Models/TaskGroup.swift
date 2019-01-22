//
//  TaskGroup.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/11.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Moya
import UIKit

struct TaskGroupCollection: Codable {
    var groups: [TaskGroup]
    var links: Links
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case groups = "data"
        case links
        case meta
    }
}

struct TaskGroup: Codable {
    var projectId: Int
    var id: Int
    var title: String
    var information: String?
    var progress: Int
    var status: String
    var type: String
    var typeColor: Int
    var statusId: Int
    var startAt: String?
    var endAt: String?
    var color: Int
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case id
        case title
        case information
        case progress
        case status
        case type
        case typeColor = "type_color"
        case statusId = "status_id"
        case startAt = "start_at"
        case endAt = "end_at"
        case color
    }
    
    enum Status: Int {
        case open = 1
        case close = 999
    }
    
    func isOpen() -> Bool {
        if self.statusId == 1 {
            return true
        } else {
            return false
        }
    }
    
    struct EditResources: Codable {
        var types: [TaskType]
        
        enum CodingKeys: String, CodingKey {
            case types
        }
        
        static func resources(project: ProjectCollection.Project, completion: @escaping (EditResources?) -> Void) {
            NetworkProvider.main.data(request: .taskGroupEditResource(project: project)) { (data) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let editResources = try! JSONDecoder.main.decode(EditResources.self, from: data)
                completion(editResources)
            }
        }
    }
    
    static func resources(project: ProjectCollection.Project, completion: @escaping (TaskGroupCollection?) -> Void) {
        NetworkProvider.main.data(request: .projectTaskGroups(project: project)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let taskGroupCollection = try! JSONDecoder.main.decode(TaskGroupCollection.self, from: data)
            completion(taskGroupCollection)
        }
    }
}

struct TaskGroupRegister {
    var id: Int?
    var title: String?
    var information: String?
    var typeId: Int?
    var statusId: Int?
    var startAt: String?
    var endAt: String?
    var colorId: Int?
    var projectId: Int?
    
    func store(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .storeTaskGroup(group: self)) { (status) in
            completion(status)
        }
    }
    
    func update(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .updateTaskGroup(group: self)) { (status) in
            completion(status)
        }
    }
}
