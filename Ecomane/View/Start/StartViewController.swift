//
//  StartViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  @IBAction func registerButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(
      withIdentifier: "Register") as? RegisterViewController {
      vc.title = "新規会員登録"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @IBAction func loginButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(
      withIdentifier: "Login") as? LoginViewController {
      vc.title = "ログイン"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
