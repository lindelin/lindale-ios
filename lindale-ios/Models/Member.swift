//
//  Member.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Moya
import UIKit

struct ProjectMember: Codable {
    var pl: Profile
    var sl: Profile?
    var members: [Profile]
    
    enum CodingKeys: String, CodingKey {
        case pl
        case sl
        case members
    }
    
    static func resources(project: ProjectCollection.Project, completion: @escaping (ProjectMember?) -> Void) {
        NetworkProvider.main.data(request: .projectMembers(project: project)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let projectMember = try! JSONDecoder.main.decode(ProjectMember.self, from: data)
            completion(projectMember)
        }
    }
}
