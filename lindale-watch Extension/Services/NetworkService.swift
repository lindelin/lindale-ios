//
//  NetworkService.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/10/03.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Moya

enum NetworkService {
    case projects
    case profile
    case myTasks
    case myTodos
}

extension NetworkService: TargetType {
    
    var baseURL: URL { return URL(string: "\(OAuth.apiUrl())/api")! }
    
    var path: String {
        switch self {
        case .projects:
            return "/projects"
        case .profile:
            return "/profile"
        case .myTasks:
            return "/tasks"
        case .myTodos:
            return "/todos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .projects, .profile, .myTasks, .myTodos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .projects, .profile, .myTasks, .myTodos:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .projects, .profile, .myTasks, .myTodos:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": OAuth.get()!.token()]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
