//
//  Setting.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation
import Moya
import UIKit

struct Settings {
    struct Locale: Codable {
        var currentLanguage: String
        var currentLanguageName: String
        var options: [String: String]
        
        enum CodingKeys: String, CodingKey {
            case currentLanguage = "current_language"
            case currentLanguageName = "current_language_name"
            case options = "options"
        }
        
        struct Option {
            var key: String
            var value: String
        }
        
        func optionObjs() -> [Option] {
            var tmp: [Option] = []
            for option in self.options {
                tmp.append(Option(key: option.key, value: option.value))
            }
            
            return tmp
        }
        
        static func load(completion: @escaping (Settings.Locale?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.localeSettings) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let localeSettings = try! coder.decode(Settings.Locale.self, from: data)
                        completion(localeSettings)
                    }
                    catch {
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
        
        static func update(to language: String, completion: @escaping (String?) -> Void) {
            let provider = MoyaProvider<NetworkService>()
            provider.request(.localeUpdate(lang: language)) { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let data = response.data
                        let coder = JSONDecoder()
                        let message = try! coder.decode([String: String].self, from: data)
                        completion(message["status"])
                    }
                    catch {
                        completion(nil)
                    }
                // do something with the response data or statusCode
                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}
