//
//  NetworkService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Moya

enum NetworkService {
    case projects
}

extension NetworkService: TargetType {
    
    var baseURL: URL { return URL(string: "\(UserDefaults.dataSuite.string(forOAuthKey: .clientUrl)!)/api")! }
    
    var path: String {
        switch self {
        case .projects:
            return "/projects"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .projects:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .projects:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .projects:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": OAuth.get()!.token()]
    }
}

enum LoadMoreService {
    case load(url: URL)
}

extension LoadMoreService: TargetType {
    var baseURL: URL {
        switch self {
        case .load(let url):
            return url
        }
    }
    var path: String { return "" }
    var method: Moya.Method { return .get }
    var sampleData: Data { return "Half measures are as bad as nothing at all.".utf8Encoded }
    var task: Task { return .requestPlain }
    var headers: [String: String]? {
        return ["Accept": "application/json", "Authorization": OAuth.get()!.token()]
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

class NetworkProvider {
    
    static let main = NetworkProvider()
    
    let provider = MoyaProvider<NetworkService>()
    let loadMoreProvider = MoyaProvider<LoadMoreService>()
    
    func data(request: NetworkService, completion: @escaping (Data?) -> Void) {
        provider.request(request) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    completion(data)
                }
                catch {
                    if response.statusCode == 401 {
                        UserDefaults.dataSuite.set(true, forOAuthKey: .hasAuthError)
                    }
                    completion(nil)
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func moreData(request: LoadMoreService, completion: @escaping (Data?) -> Void) {
        loadMoreProvider.request(request) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    completion(data)
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
    
    func message(request: NetworkService, completion: @escaping ([String: String]) -> Void) {
        provider.request(request) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let status = try! coder.decode([String: String].self, from: data)
                    completion(status)
                }
                catch {
                    if response.statusCode == 422 {
                        let data = response.data
                        let coder = JSONDecoder()
                        let errors = try! coder.decode(InputError.self, from: data)
                        var message: String = ""
                        for errors in errors.errors {
                            for error in errors.value {
                                message += error
                            }
                        }
                        completion(["status": errors.message, "messages": message])
                    } else {
                        print(error)
                        completion(["status": "NG", "messages": "Network Error!"])
                    }
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                completion(["status": "NG", "messages": "Network Error!"])
            }
        }
    }
}
