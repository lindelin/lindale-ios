//
//  User.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/11/15.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

struct User: Codable {
    var id: Int
    var name: String
    var email: String
    var photo: URL
    var content: String?
    var company: String?
    var location: String?
    var created: String
    var updated: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case photo
        case content
        case company
        case location
        case created = "created_at"
        case updated = "updated_at"
    }
}
