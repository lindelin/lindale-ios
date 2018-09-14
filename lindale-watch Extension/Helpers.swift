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
        let url = URL(string:url)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.setImage(image)
                }
            }
        }
        task.resume()
    }
    
}
