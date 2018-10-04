//
//  OAuth.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/10/03.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation

struct OAuth {
    var type: String
    var accessToken: String
    
    static var isLogined: Bool {
        if UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.accessToken.rawValue) == nil {
            return false
        }
        return true
    }
    
    static func get() -> OAuth? {
        if UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.accessToken.rawValue) == nil {
            return nil
        }
        let accessToken = UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.accessToken.rawValue) ?? nil!
        let type = UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.type.rawValue) ?? nil!
        
        return OAuth(type: type, accessToken: accessToken)
    }
    
    func token() -> String {
        return self.type + " " + self.accessToken
    }
    
    static func apiUrl() -> String {
        return UserDefaults.dataSuite.string(forKey: UserDefaults.OAuthKeys.clientUrl.rawValue)!
    }
    
    static func store(info value: [String: Any]) {
        UserDefaults.dataSuite.set(value[UserDefaults.OAuthKeys.clientUrl.rawValue] as! String, forKey: UserDefaults.OAuthKeys.clientUrl.rawValue)
        UserDefaults.dataSuite.set(value[UserDefaults.OAuthKeys.accessToken.rawValue] as! String, forKey: UserDefaults.OAuthKeys.accessToken.rawValue)
        UserDefaults.dataSuite.set(value[UserDefaults.OAuthKeys.type.rawValue] as! String, forKey: UserDefaults.OAuthKeys.type.rawValue)
        UserDefaults.dataSuite.synchronize()
        print("Auth Info 保存成功")
    }
}
