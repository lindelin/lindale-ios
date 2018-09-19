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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    enum keys: String {
        case authentication = "authentication"
    }
    
    fileprivate var validationMessage = "Login faild!"
    
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
        let email = self.email.text!
        let password = self.password.text!
        OAuth.login(email: email, password: password, success: { (oauth) in
            OAuth.save(oauth)
            self.toMainStoryboard()
        }) { () in
            self.showLoginAlert()
        }
    }
    
    // MARK: - パスワードリセット
    @IBAction func resetPasswordButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: LoginViewController.keys.authentication.rawValue)
        let url = "https://lindale.stg.lindelin.org/password/reset"   // 仮URL
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        let navigationController = UINavigationController(rootViewController: safariViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Main 画面遷移
    func toMainStoryboard() {
        if self.presentingViewController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "MainController") as! UITabBarController
            mainController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(mainController, animated: true, completion: nil)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - ログイン失敗
    func showLoginAlert() {
        let loginErrorAlert = UIAlertController(title: "Login error", message: self.validationMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            loginErrorAlert.dismiss(animated: true, completion: nil)
        })
        
        loginErrorAlert.addAction(okAction)
        
        if self.presentingViewController == nil {
            self.view.window?.rootViewController?.present(loginErrorAlert, animated: true, completion: nil)
        }else {
            self.present(loginErrorAlert, animated: true, completion: nil)
        }
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
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
