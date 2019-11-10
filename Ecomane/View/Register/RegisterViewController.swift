//
//  RegisterViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
  }

  @IBAction func registerButton(_ sender: Any) {
    register()
  }
  
  func register() {
   Auth.auth().createUser(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { (user, error) in
    
      if error != nil {
        print("登録できませんでした")
      }
      else {
        print("登録できました")
       self.setdata()
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(
          withIdentifier: "Login") as? LoginViewController {
          vc.title = "ログイン"
          self.navigationController?.pushViewController(vc, animated: true)
        }
      }
    }
  }
  
  func setdata() {
    if let currentUser = Auth.auth().currentUser { //データが取得できなかったらスキップ。
      let user = Firestore.User(id: currentUser.uid)
      user.save()
    }
  }
}
