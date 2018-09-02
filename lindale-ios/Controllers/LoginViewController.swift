//
//  LoginViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/30.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import Pastel

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
            loginButton.layer.borderWidth = 1.0
            loginButton.layer.cornerRadius = 4
        }
    }
    
    fileprivate var validationMessage = "Login faild!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    // キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
    
    // MARK: - Main 画面遷移
    func toMainStoryboard() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "MainController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainController
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
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
