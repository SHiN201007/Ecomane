//
//  StartViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {
  
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var guests: UIButton!
  @IBOutlet weak var contentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(red: 181/255, green: 217/255, blue: 235/255, alpha: 1.0)
    contentView.layer.cornerRadius = 7.0
    customCSS()
  }
  
  func customCSS() {
    registerButton.backgroundColor = .systemPink
    registerButton.layer.cornerRadius = 7.0
    registerButton.setTitleColor(.white, for: .normal)
    registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    registerButton.layer.borderColor = UIColor.darkGray.cgColor
    registerButton.layer.borderWidth = 1.0
    
    loginButton.backgroundColor = .white
    loginButton.layer.cornerRadius = 7.0
    loginButton.setTitleColor(.black, for: .normal)
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    loginButton.layer.borderColor = UIColor.darkGray.cgColor
    loginButton.layer.borderWidth = 1.0
    
    guests.backgroundColor = .white
    guests.layer.cornerRadius = 7.0
    guests.setTitleColor(.black, for: .normal)
    guests.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    guests.layer.borderColor = UIColor.darkGray.cgColor
    guests.layer.borderWidth = 1.0
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
  
  @IBAction func guests(_ sender: Any) {
    //匿名ユーザーとしてログイン
    Auth.auth().signInAnonymously { (result, error) in
      if (result?.user) != nil{
        if let currentUser = Auth.auth().currentUser { //データが取得できなかったらスキップ。
          let user = Firestore.User(id: currentUser.uid)
          let input = Firestore.Input()
          user.inputs.insert(input)
          input.delete()
          user.save()
          self.dismiss(animated: true, completion: nil)
        }
        //UserDefaultsに値を登録
        let loginID = 1
        UserDefaults.standard.set(loginID, forKey: "loginID")
      }
    }
  }
  

  
  
}
