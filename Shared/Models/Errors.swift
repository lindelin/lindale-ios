//
//  Errors.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation

struct InputError: Codable {
    var message: String
    var errors: [String: [String]]
    
    enum CodingKeys: String, CodingKey {
        case message
        case errors
    }
}
