//
//  Helpers.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
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

extension UITableViewController {
    func logout() {
        if (OAuth.logout()) {
            let storyboard = UIStoryboard(name:"Login", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "Login")
            loginController.hidesBottomBarWhenPushed = true
            loginController.modalTransitionStyle = .crossDissolve
            self.present(loginController, animated: true, completion: nil)
        }
    }
}

func image_from(url: String) -> UIImage {
    let url = URL(string: url)
    do {
        let data = try Data(contentsOf: url!)
        return UIImage(data: data)!
    } catch {
        return #imageLiteral(resourceName: "lindale-launch")
    }
}
