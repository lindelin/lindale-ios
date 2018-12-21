//
//  Helpers.swift
//  lindale-task-notification-ui
//
//  Created by Jie Wu on 2018/12/21.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

func image_from(url: URL?) -> UIImage {
    guard let url = url, let data =  try? Data(contentsOf: url) else {
        return #imageLiteral(resourceName: "lindale-launch")
    }
    
    return UIImage(data: data)!
}

extension JSONDecoder {
    static let main = JSONDecoder()
}
