//
//  UserDefaults+DataSource.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/28.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /// - Tag: app_group
    // Note: This project does not share data between iOS and watchOS. Orders placed on the watch will not display in the iOS order history.
    private static let AppGroup = "group.lindale"
    
    static let dataSuite = { () -> UserDefaults in
        guard let dataSuite = UserDefaults(suiteName: AppGroup) else {
            fatalError("Could not load UserDefaults for app group \(AppGroup)")
        }
        
        return dataSuite
    }()
}
