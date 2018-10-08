//
//  Oauth.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//
import UIKit
import Moya
import Firebase
import KRProgressHUD

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
    
    static func configure() {
        KRProgressHUD.show(withMessage: "Loading...")
        let ref = Database.database().reference()
        ref.child("system").child("oauth").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            UserDefaults.dataSuite.set(value?[UserDefaults.OAuthKeys.clientUrl.rawValue] as! String, forKey: UserDefaults.OAuthKeys.clientUrl.rawValue)
            UserDefaults.dataSuite.set(value?[UserDefaults.OAuthKeys.clientId.rawValue] as! Int, forKey: UserDefaults.OAuthKeys.clientId.rawValue)
            UserDefaults.dataSuite.set(value?[UserDefaults.OAuthKeys.clientSecret.rawValue] as! String, forKey: UserDefaults.OAuthKeys.clientSecret.rawValue)
            UserDefaults.dataSuite.synchronize()
            
            if let oauth = OAuth.get() {
                WatchSession.main.sendMessageByBackground([
                        "type": "AuthInfo",
                        "data": [
                            UserDefaults.OAuthKeys.clientUrl.rawValue: UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.clientUrl.rawValue)!,
                            UserDefaults.OAuthKeys.accessToken.rawValue: oauth.accessToken,
                            UserDefaults.OAuthKeys.type.rawValue: oauth.type,
                        ]
                    ])
            }
            
            KRProgressHUD.dismiss()
        }) { (error) in
            print(error.localizedDescription)
        }
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
                    print("error", error)
                    errorCallback()
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("error", error)
                errorCallback()
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
        UserDefaults.dataSuite.set(oauth.accessToken, forKey: UserDefaults.OAuthKeys.accessToken.rawValue)
        UserDefaults.dataSuite.set(oauth.type, forKey: UserDefaults.OAuthKeys.type.rawValue)
        UserDefaults.dataSuite.set(oauth.refreshToken, forKey: UserDefaults.OAuthKeys.refreshToken.rawValue)
        UserDefaults.dataSuite.set(oauth.expires, forKey: UserDefaults.OAuthKeys.expires.rawValue)
        UserDefaults.dataSuite.synchronize()
    }
    
    static func get() -> OAuth? {
        if UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.accessToken.rawValue) == nil {
            return nil
        }
        let accessToken = UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.accessToken.rawValue) ?? nil!
        let type = UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.type.rawValue) ?? nil!
        let refreshToken = UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.refreshToken.rawValue) ?? nil!
        let expires = UserDefaults.dataSuite.integer(forKey: UserDefaults.OAuthKeys.expires.rawValue)
        return OAuth(type: type, expires: expires, accessToken: accessToken, refreshToken: refreshToken)
    }
    
    static func logout() -> Bool {
        UserDefaults.dataSuite.removeObject(forKey: UserDefaults.OAuthKeys.accessToken.rawValue)
        UserDefaults.dataSuite.removeObject(forKey: UserDefaults.OAuthKeys.type.rawValue)
        UserDefaults.dataSuite.removeObject(forKey: UserDefaults.OAuthKeys.refreshToken.rawValue)
        UserDefaults.dataSuite.removeObject(forKey: UserDefaults.OAuthKeys.expires.rawValue)
        UserDefaults.dataSuite.synchronize()
        return true
    }
    
    func token() -> String {
        return self.type + " " + self.accessToken
    }
}
