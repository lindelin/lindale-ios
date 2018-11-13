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

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            errorAlert.dismiss(animated: true, completion: nil)
        })
        
        errorAlert.addAction(okAction)
        
        if self.presentingViewController == nil {
            self.view.window?.rootViewController?.present(errorAlert, animated: true, completion: nil)
        }else {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func logout() {
        if (OAuth.logout()) {
            let storyboard = UIStoryboard(name:"Login", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "Login")
            loginController.hidesBottomBarWhenPushed = true
            loginController.modalTransitionStyle = .crossDissolve
            self.present(loginController, animated: true, completion: nil)
        }
    }
    
    func authErrorHandle() {
        if UserDefaults.dataSuite.bool(forOAuthKey: .hasAuthError) {
            UserDefaults.dataSuite.set(false, forOAuthKey: .hasAuthError)
            let errorAlert = UIAlertController(title: "認証エラー", message: "ログインしてください。", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                errorAlert.dismiss(animated: true, completion: nil)
                self.logout()
            })
            
            errorAlert.addAction(okAction)
            
            if self.presentingViewController == nil {
                self.view.window?.rootViewController?.present(errorAlert, animated: true, completion: nil)
            }else {
                self.present(errorAlert, animated: true, completion: nil)
            }
            // TODO: 刷新令牌
//            OAuth.refresh { (oauth) in
//                if let _ = oauth {
//                    self.showAlert(title: nil, message: "Network Error")
//                } else {
//                    let errorAlert = UIAlertController(title: "認証エラー", message: "ログインしてください。", preferredStyle: .alert)
//
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
//                        errorAlert.dismiss(animated: true, completion: nil)
//                        self.logout()
//                    })
//
//                    errorAlert.addAction(okAction)
//
//                    if self.presentingViewController == nil {
//                        self.view.window?.rootViewController?.present(errorAlert, animated: true, completion: nil)
//                    }else {
//                        self.present(errorAlert, animated: true, completion: nil)
//                    }
//                }
//            }
        } else {
            self.showAlert(title: nil, message: "Network Error")
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
