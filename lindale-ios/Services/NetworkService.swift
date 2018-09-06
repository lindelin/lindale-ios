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
}

extension NetworkService: TargetType {
    
    var baseURL: URL { return URL(string: "https://lindale.stg.lindelin.org/api")! }
    
    var path: String {
        switch self {
            case .projects:
                return "/projects"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .projects:
                return .get
        }
    }
    
    var task: Task {
        switch self {
            case .projects:
               return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
            case .projects:
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
