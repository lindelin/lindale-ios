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

extension UIImageView {
    func load(url: URL?, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        
        guard let url = url else {
            self.image = placeholder
            return
        }
        
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async() { () -> Void in
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
