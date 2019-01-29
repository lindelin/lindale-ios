//
//  LoginViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/30.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Pastel
import SafariServices
import UserNotifications

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 1.5
        pastelView.setColors([
            Colors.themeMain,
            Colors.themeYellow,
            Colors.themeGreen,
            Colors.themeBlue,
            Colors.themeBaseOptional,
            Colors.themeBase,
            Colors.themeBaseSub,
            Colors.themeMainOptional,
            Colors.themeSub
        ])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
        // Do any additional setup after loading the view.
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - Setup
    func setup() {
        email.delegate = self
        password.delegate = self
    }
    
    // MARK: - ログイン
    @IBAction func login(_ sender: UIButton) {
        let email = self.email.text ?? ""
        let password = self.password.text ?? ""
        OAuth.login(email: email, password: password, success: { (oauth) in
            UserDefaults.standard.set(email, forOAuthKey: .userName)
            oauth.save()
            self.setPushNotification()
            self.toMainStoryboard()
        }) { (message) in
            if let message = message {
                self.showLoginAlert(message)
            } else {
                self.showLoginAlert()
            }
        }
    }
    
    // MARK: - パスワードリセット
    @IBAction func resetPasswordButton(_ sender: Any) {
        let url = URL(string: "\(UserDefaults.dataSuite.string(forOAuthKey: .clientUrl) ?? "https://lindale.lindelin.org")/password/reset")!
        let safariViewController = SFSafariViewController(url: url)
        let navigationController = UINavigationController(rootViewController: safariViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func setPushNotification() {
        if let fcmToken = UserDefaults.standard.string(forOAuthKey: .fcmToken) {
            DispatchQueue.main.async {
                Device(token: fcmToken).store(completion: { (response) in
                    guard response["status"] == "OK" else {
                        print("Store Firebase token Error: \(String(describing: response["messages"]))")
                        return
                    }
                    print("Store Firebase token OK: \(String(describing: response["messages"]))")
                })
            }
        }
    }
    
    // MARK: - Main 画面遷移
    func toMainStoryboard() {
        // [START register_for_notifications]
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        let unUserNotificationCenter = UNUserNotificationCenter.current()
        unUserNotificationCenter.requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        unUserNotificationCenter.delegate = appDelegate
        UIApplication.shared.registerForRemoteNotifications()
        // [END register_for_notifications]
        LanguageService.sync { (data) in
            guard let _ = data  else {
                self.showLoginAlert()
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "MainController") as! UITabBarController
            UIView.transition(from: self.view, to: mainController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: {
                _ in
                UIApplication.shared.keyWindow?.rootViewController = mainController
            })
        }
    }
    
    // MARK: - ログイン失敗
    func showLoginAlert(_ message: String? = nil) {
        
        let networkError = "Network Error!"
        
        let loginErrorAlert = UIAlertController(title: "Login error", message: message ?? networkError, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            loginErrorAlert.dismiss(animated: true, completion: nil)
        })
        
        loginErrorAlert.addAction(okAction)
        
        self.present(loginErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: - Doneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            // タグが0ならsecondTextFieldにフォーカスを当てる
            password.becomeFirstResponder()
            break
        case 2:
            // タグが1ならキーボードを閉じる
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
