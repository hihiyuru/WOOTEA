//
//  LoginViewController.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/13.
//

import UIKit

class LoginViewController: UIViewController {
    var isSignIn = true
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var handlerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIStatus()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setUIStatus() {
        if isSignIn {
            statusButton.backgroundColor = UIColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1)
            statusButton.setTitle("我要註冊", for: .normal)
            handlerButton.backgroundColor = .systemCyan
            handlerButton.setTitle("登入", for: .normal)
            emailTextField.isHidden = true
            usernameTextField.placeholder = "請輸入email或用戶名"
        } else {
            statusButton.backgroundColor = .systemCyan
            statusButton.setTitle("去登入", for: .normal)
            handlerButton.backgroundColor = UIColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1)
            handlerButton.setTitle("註冊", for: .normal)
            emailTextField.isHidden = false
            usernameTextField.placeholder = "請輸入用戶名包含a-z、0-9和_"
        }
    }
    
    func changSign() {
        isSignIn = !isSignIn
        setUIStatus()
    }
    
    @IBAction func changStatus(_ sender: UIButton) {
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        changSign()
    }
    
    @IBAction func handlerSign(_ sender: UIButton) {
        print("handlerSign called. isSignIn: \(isSignIn)")
        if isSignIn {
            login()
        } else {
            signUp()
        }
    }
    
    func login() {
        print("登入")
        guard let login = usernameTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(on: self, title: "請填寫完整資料", message: "", buttonTitle: "知道了")
            return
        }
        let user = SignIn(login: login, password: password)
        let stringUrl = "https://favqs.com/api/session"
        guard let url = URL(string: stringUrl) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\"42038ca3386f1951f46ce53ec29a9a45\"", forHTTPHeaderField: "Authorization")
        if let updateBody = try? JSONEncoder().encode(User(user: user)) {
            if let jsonString = String(data: updateBody, encoding: .utf8) {
                print("要上傳的: \(jsonString)")
            }
            urlRequest.httpBody = updateBody
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Error:", error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let content = try JSONDecoder().decode(SignInResponse.self, from: data)
                        DispatchQueue.main.async {
                            
                            
                            if ((content.errorCode) != nil) {
                                showAlert(on: self, title: "登入失敗\(content.errorCode!)", message: "\(content.message!)", buttonTitle: "請再試一次")
                            } else {
                                showAlert(on: self, title: "登入成功", message: "", buttonTitle: "開始訂餐") { _ in
                                    self.usernameTextField.text = ""
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    // 儲存資料
                                    let usrDefaults = UserDefaults.standard
                                    usrDefaults.set(content.login, forKey: "user")
                                    // 跳轉
                                    if let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "AppTabBarController") as? UITabBarController {
                                        tabBarVC.modalPresentationStyle = .fullScreen
                                        self.present(tabBarVC, animated: true, completion: nil)
                                    }
                                }
                                
                            }
                        }
                        
                    } catch {
                        print(error)
                        showAlert(on: self, title: "註冊失敗！", message: "", buttonTitle: "重新註冊")
                    }
                }
            }.resume()
        } else {
            print("Failed to encode User.")
        }
    }
    
    func signUp() {
        print("註冊")
        guard let login = usernameTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(on: self, title: "請填寫完整資料", message: "", buttonTitle: "知道了")
            return
        }
        let user = SignIn(login: login, email: email, password: password)
        let stringUrl = "https://favqs.com/api/users"
        guard let url = URL(string: stringUrl) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\"42038ca3386f1951f46ce53ec29a9a45\"", forHTTPHeaderField: "Authorization")
        if let updateBody = try? JSONEncoder().encode(User(user: user)) {
            if let jsonString = String(data: updateBody, encoding: .utf8) {
                print("要上傳的: \(jsonString)")
            }
            urlRequest.httpBody = updateBody
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Error:", error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let content = try JSONDecoder().decode(SignUpResponse.self, from: data)
                        DispatchQueue.main.async {
                            if ((content.errorCode) != nil) {
                                showAlert(on: self, title: "註冊失敗\(content.errorCode!)", message: "\(content.message!)", buttonTitle: "重新註冊")
                            } else {
                                showAlert(on: self, title: "註冊成功", message: "請重新登入", buttonTitle: "馬上去登入") { _ in
                                    self.changSign()
                                }
                            }
                            
                        }
                        
                    } catch {
                        print(error)
                        showAlert(on: self, title: "註冊失敗！", message: "", buttonTitle: "重新註冊")
                    }
                }
            }.resume()
        } else {
            print("Failed to encode User.")
        }
    }
    
}
