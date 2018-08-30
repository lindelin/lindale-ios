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
    
    static func request(email: String, password: String, completion: @escaping (Token) -> Void) {
        let provider = MoyaProvider<OAuthService>()
        provider.request(.login(email: email, password: password)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let token = try! JSONDecoder.use().decode(Token.self, from: data)
                completion(token)
                
            // do something with the response data or statusCode
            case let .failure(error):
                print("error", error)
            }
        }
    }
}
