//
//  Helpers.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            errorAlert.dismiss(animated: true, completion: nil)
        })
        
        errorAlert.addAction(okAction)
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func logout() {
        if (OAuth.logout()) {
            let storyboard = UIStoryboard(name:"Login", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "Login")
            UIView.transition(from: self.tabBarController!.view, to: loginController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: {
                _ in
                UIApplication.shared.keyWindow?.rootViewController = loginController
            })
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
            
            self.present(errorAlert, animated: true, completion: nil)
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
        } else if UserDefaults.dataSuite.bool(forOAuthKey: .hasAuthorizationError) {
            UserDefaults.dataSuite.set(false, forOAuthKey: .hasAuthorizationError)
            let errorAlert = UIAlertController(title: "権限エラー", message: "権限がありません。", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                errorAlert.dismiss(animated: true, completion: nil)
            })
            
            errorAlert.addAction(okAction)
            
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            self.showAlert(title: nil, message: "Network Error")
        }
    }
}
