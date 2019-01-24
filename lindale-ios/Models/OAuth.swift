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
        KRProgressHUD.show()
        let ref = Database.database().reference()
        ref.child("system").child("oauth").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            UserDefaults.dataSuite.set(value?[UserDefaults.OAuthKeys.clientUrl.rawValue] as! String, forOAuthKey: .clientUrl)
            UserDefaults.dataSuite.set(value?[UserDefaults.OAuthKeys.clientId.rawValue] as! Int, forOAuthKey: .clientId)
            UserDefaults.dataSuite.set(value?[UserDefaults.OAuthKeys.clientSecret.rawValue] as! String, forOAuthKey: .clientSecret)
            UserDefaults.dataSuite.synchronize()
            
            if let oauth = OAuth.get() {
                WatchSession.main.sendMessageByBackground([
                        "type": "AuthInfo",
                        "data": [
                            UserDefaults.OAuthKeys.clientUrl.rawValue: UserDefaults.dataSuite.string(forOAuthKey: .clientUrl)!,
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
                        error errorCallback: @escaping (String?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let provider = MoyaProvider<OAuthService>()
        provider.request(.login(email: email, password: password)) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
                    if response.statusCode == 401 {
                        errorCallback("The user credentials were incorrect.")
                    } else {
                        errorCallback(nil)
                    }
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("error", error)
                errorCallback(nil)
            }
        }
    }
    
    static func refresh(completion: @escaping (OAuth?) -> Void) {
        let provider = MoyaProvider<OAuthService>()
        provider.request(.refresh) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let oauth = try! coder.decode(OAuth.self, from: data)
                    oauth.save()
                    completion(oauth)
                }
                catch {
                    print("error", error)
                    completion(nil)
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("error", error)
                completion(nil)
            }
        }
    }
    
    func save() {
        UserDefaults.dataSuite.set(self.accessToken, forOAuthKey: .accessToken)
        UserDefaults.dataSuite.set(self.type, forOAuthKey: .type)
        UserDefaults.dataSuite.set(self.refreshToken, forOAuthKey: .refreshToken)
        UserDefaults.dataSuite.set(self.expires, forOAuthKey: .expires)
        UserDefaults.dataSuite.synchronize()
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
    
    static func logout() -> Bool {
        UserDefaults.dataSuite.removeObject(forOAuthKey: .accessToken)
        UserDefaults.dataSuite.removeObject(forOAuthKey: .type)
        UserDefaults.dataSuite.removeObject(forOAuthKey: .refreshToken)
        UserDefaults.dataSuite.removeObject(forOAuthKey: .expires)
        UserDefaults.dataSuite.synchronize()
        return true
    }
    
    func token() -> String {
        return self.type + " " + self.accessToken
    }
}
