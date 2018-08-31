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
    var baseURL: URL { return URL(string: "https://lindale.stg.lindelin.org/api")! }
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
        return ["Accept": "application/json", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjJkM2E3MjNiZmNmNGUyZDA3YzYwYmNkZDgzMmRiNDhhZDdmMzE2ZjNiMjM0MDI1YTVmNGIwMGRiZWZjZjZkNjIwYTZmMTE1NDQwZjA5Yzc3In0.eyJhdWQiOiIxIiwianRpIjoiMmQzYTcyM2JmY2Y0ZTJkMDdjNjBiY2RkODMyZGI0OGFkN2YzMTZmM2IyMzQwMjVhNWY0YjAwZGJlZmNmNmQ2MjBhNmYxMTU0NDBmMDljNzciLCJpYXQiOjE1MzU2ODY1MDQsIm5iZiI6MTUzNTY4NjUwNCwiZXhwIjoxNTM2OTgyNTA0LCJzdWIiOiIzIiwic2NvcGVzIjpbIioiXX0.LX32G52ZZjmRo0ub0bJu5welYt_pc4F5Rrl2ZyM_g9wWnoWnzC6SH-fxx3gJ8GHoQHsLB86ILNpuHIpWir5s9wq-xNn7g9XTN8HgZXWDixnEdV3VhO5x6TskS7f5ZsGcJ1H79EMrVX7be1d9zPSOEexNM4n4bmQwaeSvHJUzm7BK_f9ls67tzzHvAOpNf2EZGAngzXR_zTmqUrWgWO42hDxvRHbJGBG7X-UB-Wi1wB_V6sI9K48Wm9wqmi4RBuN3Scd_K4fE2wJOSeB1P7laz7M7tLYsUVznZkCzXOm7kw2tP8f8wUGUTqi8QS_cJhqHTZJyv1j6v9y6BmuOqGNctjdO9qjQerwcgeDnW31jU3huzcBQ79XFGU-QcR3lhogxjOIZeuPQS-QA-RzRvjthPemNKU5DJ4FgijwZimykWc9brXQsMQEdfxwyCnmkC3GepkZGL5L-Qxu4Ofc5aMeAWr2aV_VWDIq9S7euyk9UXU0_Kcwwy9UV3jbeZctuzxpE2jeFij-h0wnFD58VCzJxMqbfOjAE0FjUhoEtn4Ginv_wuxPuHsFkuGcn4q_JPLI2kD4eXp_mhZNMy5rJWgpnsafaJmk9ntRJ5KTV4rbVv0ZmqEIurZUVVE3w5DqJUx_304F7HldWFE28A5eRHNatafkjJn1Lcs_ppLu-M7pdiZA"]
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
