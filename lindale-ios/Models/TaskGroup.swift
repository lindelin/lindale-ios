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
