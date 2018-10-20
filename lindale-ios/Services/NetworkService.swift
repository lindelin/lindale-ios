//
//  NetworkService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Moya

enum NetworkService {
    case projects
    case profile
    case myTasks
    case myTodos
    case myTaskDetail(id: Int)
    case localeSettings
    case localeUpdate(lang: String)
}

extension NetworkService: TargetType {
    
    var baseURL: URL { return URL(string: "\(UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.clientUrl.rawValue)!)/api")! }
    
    var path: String {
        switch self {
        case .projects:
            return "/projects"
        case .profile:
            return "/profile"
        case .myTasks:
            return "/tasks"
        case .myTaskDetail(let id):
            return "/tasks/\(id)"
        case .myTodos:
            return "/todos"
        case .localeSettings:
            return "/settings/locale"
        case .localeUpdate:
            return "/settings/locale"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings:
            return .get
        case .localeUpdate:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings:
            return .requestPlain
        case let .localeUpdate(lang):
            return .requestParameters(parameters: ["language": lang], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
            case .projects, .profile, .myTasks, .myTodos, .myTaskDetail, .localeSettings, .localeUpdate:
                return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": (OAuth.get()?.token())!]
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
