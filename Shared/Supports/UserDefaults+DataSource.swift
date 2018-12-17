//
//  UserDefaults+DataSource.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/28.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /// - Tag: app_group
    // Note: This project does not share data between iOS and watchOS. Orders placed on the watch will not display in the iOS order history.
    public static let AppGroup = "group.lindelin.lindale"
    
    enum OAuthKeys: String {
        case clientUrl = "client_url"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case type = "token_type"
        case expires = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case hasAuthError = "has_auth_error"
        case fcmToken = "fcm_token"
        case didOpenPushNotification
        case userName = "user_name"
    }
    
    func set(_ value: Any?, forOAuthKey key: OAuthKeys) {
        self.set(value, forKey: key.rawValue)
    }
    
    func string(forOAuthKey key: OAuthKeys) -> String? {
        return self.string(forKey: key.rawValue)
    }
    
    func bool(forOAuthKey key: OAuthKeys) -> Bool {
        return self.bool(forKey: key.rawValue)
    }
    
    func integer(forOAuthKey key: OAuthKeys) -> Int {
        return self.integer(forKey: key.rawValue)
    }
    
    func removeObject(forOAuthKey key: OAuthKeys) {
        self.removeObject(forKey: key.rawValue)
    }
    
    static let dataSuite = { () -> UserDefaults in
        guard let dataSuite = UserDefaults(suiteName: AppGroup) else {
            fatalError("Could not load UserDefaults for app group \(AppGroup)")
        }
        
        return dataSuite
    }()
}
