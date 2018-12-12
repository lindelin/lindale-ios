//
//  Wiki.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Moya
import UIKit

struct WikiType: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    static func resources(project: ProjectCollection.Project, completion: @escaping ([WikiType]?) -> Void) {
        NetworkProvider.main.data(request: .projectWikiTypes(project: project)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let wikiTypes = try! JSONDecoder.main.decode([WikiType].self, from: data)
            completion(wikiTypes)
        }
    }
}
