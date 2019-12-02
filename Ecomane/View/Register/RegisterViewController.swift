//
//  RegisterViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class RegisterViewController: UIViewController {

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var contentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailField.delegate = self
    passwordField.delegate = self
    contentView.layer.cornerRadius = 7.0
    view.backgroundColor = UIColor(red: 181/255, green: 217/255, blue: 235/255, alpha: 1.0)
    customCSS()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
  }
  
  func customCSS() {
    registerButton.backgroundColor = .systemPink
    registerButton.layer.cornerRadius = 7.0
    registerButton.setTitleColor(.white, for: .normal)
    registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    
    loginButton.backgroundColor = .white
    loginButton.layer.cornerRadius = 7.0
    loginButton.setTitleColor(.black, for: .normal)
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    loginButton.layer.borderColor = UIColor.darkGray.cgColor
    loginButton.layer.borderWidth = 1.0
  }

  @IBAction func registerButton(_ sender: Any) {
    register()
  }
  
  @IBAction func loginButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(
      withIdentifier: "Login") as? LoginViewController {
      vc.title = "ログイン"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  
  func register() {
    Auth.auth().createUser(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { (user, error) in
      HUD.show(.progress)
      if error != nil {
        print("登録できませんでした")
        HUD.show(.error)
        HUD.hide(afterDelay: 1.0)
      }
      else {
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
    HUD.show(.progress)
      Auth.auth().currentUser?.sendEmailVerification { (error) in
        if let currentUser = Auth.auth().currentUser {
        let user = Firestore.User(id: currentUser.uid)
        let input = Firestore.Input()
        user.inputs.insert(input)
        input.delete()
        user.save()
      }
    }
    HUD.flash(.success, delay: 1.0)
  }
}

//MARK:- TextField Delegate
extension RegisterViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()

    return true
  }

}
