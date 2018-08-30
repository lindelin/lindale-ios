//
//  OAuthService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//
import UIKit
import Moya

enum OAuthService {
    case login(email: String, password: String)
}

extension OAuthService: TargetType {
    var baseURL: URL { return URL(string: "https://lindale.stg.lindelin.org")! }
    var path: String {
        switch self {
        case .login(_, _):
            return "/oauth/token"
        }
    }
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters: [
                "grant_type": "password",
                "client_id": 2,
                "client_secret": "gMcCi7eMmibbYfzQsgE7129VHKpU28o8Fp6U79tY",
                "username": email,
                "password": password,
                "scope": "*"
                ], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        switch self {
        case .login:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
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
