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
    case refresh
}

extension OAuthService: TargetType {
    var baseURL: URL { return URL(string: UserDefaults.dataSuite.string(forOAuthKey: .clientUrl) ?? "")! }
    var path: String {
        switch self {
            case .login(_, _):
                return "/oauth/token"
            case .refresh:
                return "/oauth/token"
        }
    }
    var method: Moya.Method {
        switch self {
            case .login, .refresh:
                return .post
        }
    }
    var task: Task {
        switch self {
            case let .login(email, password):
                return .requestParameters(parameters: [
                    "grant_type": "password",
                    "client_id": UserDefaults.dataSuite.integer(forOAuthKey: .clientId),
                    "client_secret": UserDefaults.dataSuite.string(forOAuthKey: .clientSecret) ?? "",
                    "username": email,
                    "password": password,
                    "scope": "*"
                    ], encoding: JSONEncoding.default)
        case .refresh:
            return .requestParameters(parameters: [
                "grant_type": "refresh_token",
                "client_id": UserDefaults.dataSuite.integer(forOAuthKey: .clientId),
                "client_secret": UserDefaults.dataSuite.string(forOAuthKey: .clientSecret) ?? "",
                "refresh_token": UserDefaults.dataSuite.string(forOAuthKey: .refreshToken) ?? "",
                "scope": "*"
                ], encoding: JSONEncoding.default)
            
        }
    }
    
    var sampleData: Data {
        switch self {
            case .login, .refresh:
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
