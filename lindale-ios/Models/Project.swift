//
//  Projects.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Moya

struct Project: Codable {
    var id: Int
    var title: String?
    var content: String?
    var start: String?
    var end: String?
    var image: String?
    var user: Int?
    var sl: Int?
    var type: String?
    var status: String?
    var progress: Int?
    var created: String?
    var updated: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case content = "content"
        case start = "start_at"
        case end = "end_at"
        case image = "image"
        case user = "user_id"
        case sl = "sl_id"
        case type = "type_id"
        case status = "status_id"
        case progress = "progress"
        case created = "created_at"
        case updated = "updated_at"
    }
    
    static func resources(success successCallback: @escaping ([Project]) -> Void,
                          error errorCallback: @escaping () -> Void) {
        let provider = MoyaProvider<NetworkService>()
        provider.request(.projects) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let data = response.data
                    let coder = JSONDecoder()
                    let projects = try! coder.decode([Project].self, from: data)
                    successCallback(projects)
                }
                catch {
                    errorCallback()
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print("エラー", error)
            }
        }
    }
}
