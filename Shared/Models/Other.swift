//
//  Other.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/11/26.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation

struct Links: Codable {
    var first: URL?
    var last: URL?
    var prev: URL?
    var next: URL?
    
    enum CodingKeys: String, CodingKey {
        case first
        case last
        case prev
        case next
    }
}

struct Meta: Codable {
    var currentPage: Int?
    var from: Int?
    var lastPage: Int?
    var path: String?
    var perPage: Int?
    var to: Int?
    var total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case path
        case perPage = "per_page"
        case to
        case total
    }
}
