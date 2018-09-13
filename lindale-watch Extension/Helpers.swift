//
//  Helpers.swift
//  lindale-watch Extension
//
//  Created by LINDALE on 2018/09/13.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import Foundation
import UIKit
import WatchKit

extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String) {
        DispatchQueue.main.async() {
            let url = URL(string:url)!
            let data = try! Data(contentsOf: url)
            let placeholder = UIImage(data: data as Data)!
            
            self.setImage(placeholder)
        }
    }
    
}
