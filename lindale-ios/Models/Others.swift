//
//  Others.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/18.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Moya
import UIKit

struct Device {
    let type: String = "iOS"
    let name: String = UIDevice.current.name
    var token: String
    
    func store(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .storeDeviceToken(device: self)) { (status) in
            completion(status)
        }
    }
}
