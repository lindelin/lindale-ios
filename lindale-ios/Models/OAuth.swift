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
    
    static func login(email: String, password: String, success successCallback: @escaping (OAuth) -> Void,
                        error errorCallback: @escaping () -> Void) {
        let provider = MoyaProvider<OAuthService>()
        provider.request(.login(email: email, password: password)) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let token = try! coder.decode(OAuth.self, from: data)
                    successCallback(token)
                }
                catch {
                    errorCallback()
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("error", error)
            }
        }
    }
    
    static func refresh() {
        let provider = MoyaProvider<OAuthService>()
        provider.request(.refresh) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let token = try! coder.decode(OAuth.self, from: data)
                    print(token)
                    self.save(token)
                }
                catch {
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("error", error)
            }
        }
    }
    
    static func save(_ oauth: OAuth) {
        UserDefaults.standard.set(oauth.accessToken, forKey: OAuth.CodingKeys.accessToken.rawValue)
        UserDefaults.standard.set(oauth.type, forKey: OAuth.CodingKeys.type.rawValue)
        UserDefaults.standard.set(oauth.refreshToken, forKey: OAuth.CodingKeys.refreshToken.rawValue)
        UserDefaults.standard.set(oauth.expires, forKey: OAuth.CodingKeys.expires.rawValue)
    }
    
    static func get() -> OAuth? {
        if UserDefaults.standard.string(forKey: OAuth.CodingKeys.accessToken.rawValue) == nil {
            return nil
        }
        let accessToken = UserDefaults.standard.string(forKey: OAuth.CodingKeys.accessToken.rawValue) ?? nil!
        let type = UserDefaults.standard.string(forKey: OAuth.CodingKeys.type.rawValue) ?? nil!
        let refreshToken = UserDefaults.standard.string(forKey: OAuth.CodingKeys.refreshToken.rawValue) ?? nil!
        let expires = UserDefaults.standard.integer(forKey: OAuth.CodingKeys.expires.rawValue)
        return OAuth(type: type, expires: expires, accessToken: accessToken, refreshToken: refreshToken)
    }
}
