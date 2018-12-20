//
//  Oauth.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//
import UIKit
import Moya

struct OAuth: Codable {
    var type: String
    var expires: Int
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case type = "token_type"
        case expires = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    static func get() -> OAuth? {
        if let accessToken = UserDefaults.dataSuite.string(forOAuthKey: .accessToken),
            let type = UserDefaults.dataSuite.string(forOAuthKey: .type),
            let refreshToken = UserDefaults.dataSuite.string(forOAuthKey: .refreshToken) {
            let expires = UserDefaults.dataSuite.integer(forOAuthKey: .expires)
            return OAuth(type: type, expires: expires, accessToken: accessToken, refreshToken: refreshToken)
        } else {
            return nil
        }
    }
    
    func token() -> String {
        return self.type + " " + self.accessToken
    }
}
