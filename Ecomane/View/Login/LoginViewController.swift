//
//  LoginViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()


  }

  @IBAction func loginButton(_ sender: Any) {
    login()
  }
  
  func login() {
    Auth.auth().signIn(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { (user, error) in

      if error != nil {
        print("ログインできませんでした")
      }
      else {
        print("ログインできました")
        //UserDefaultsに値を登録
        let loginID = 1
        UserDefaults.standard.set(loginID, forKey: "loginID")
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
}
