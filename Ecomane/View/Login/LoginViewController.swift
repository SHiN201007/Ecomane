//
//  LoginViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var resetPassWord: UIButton!
  @IBOutlet weak var contentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailField.delegate = self
    passwordField.delegate = self
    
    view.backgroundColor = UIColor(red: 181/255, green: 217/255, blue: 235/255, alpha: 1.0)
    contentView.layer.cornerRadius = 7.0
    customCSS()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
  }

  @IBAction func loginButton(_ sender: Any) {
    login()
  }
  
  func customCSS() {
    loginButton.backgroundColor = .systemPink
    loginButton.layer.cornerRadius = 7.0
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    loginButton.layer.borderColor = UIColor.darkGray.cgColor
    loginButton.layer.borderWidth = 1.0
    
    registerButton.backgroundColor = .white
    registerButton.layer.cornerRadius = 7.0
    registerButton.setTitleColor(.black, for: .normal)
    registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    registerButton.layer.borderColor = UIColor.darkGray.cgColor
    registerButton.layer.borderWidth = 1.0
    
    resetPassWord.backgroundColor = .white
    resetPassWord.layer.cornerRadius = 7.0
    resetPassWord.setTitleColor(.black, for: .normal)
    resetPassWord.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    registerButton.layer.borderColor = UIColor.darkGray.cgColor
    resetPassWord.layer.borderWidth = 1.0
  }
  
  @IBAction func registerButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(
      withIdentifier: "Register") as? RegisterViewController {
      vc.title = "新規会員登録"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func login() {
    HUD.show(.progress)
    Auth.auth().signIn(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { (user, error) in
      if error != nil {
        print("ログインできませんでした")
        HUD.show(.error)
        HUD.hide(afterDelay: 1.0)
      }
      else {
        print("ログインできました")
        HUD.flash(.success, delay: 1.0)
        //UserDefaultsに値を登録
        let loginID = 1
        UserDefaults.standard.set(loginID, forKey: "loginID")
        self.dismiss(animated: true, completion: nil)
      }
    }
    
  }
  
  @IBAction func reset(_ sender: Any) {
    if let vc = UIStoryboard(name: "ResetPassWord", bundle: nil).instantiateViewController(
      withIdentifier: "ResetPassWord") as? ResetPassWordViewController {
      vc.title = "パスワードを忘れた方"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}

//MARK:- TextField Delegate
extension LoginViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()

    return true
  }

}
